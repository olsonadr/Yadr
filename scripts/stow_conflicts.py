#!/usr/bin/env python3
"""Preview and safely resolve unmanaged targets before GNU Stow replaces them."""

from __future__ import annotations

import argparse
import difflib
import hashlib
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Sequence


CONFLICT_LINE = re.compile(r"^CONFLICT when stowing .+?: .+: (.+)$")
DIRECTORY_CONFLICT_LINE = re.compile(
    r"^stow: ERROR: stow_contents\(\) called with non-directory path: (.+)$"
)
MAX_DIFF_BYTES = 16 * 1024
MAX_DIFF_LINES = 100


@dataclass(frozen=True)
class Conflict:
    relative_path: Path
    target: Path
    source: Path | None


def md5(path: Path) -> str | None:
    try:
        digest = hashlib.md5()
        with path.open("rb") as stream:
            for block in iter(lambda: stream.read(65536), b""):
                digest.update(block)
        return digest.hexdigest()
    except (OSError, IsADirectoryError):
        return None


def display_diff(conflict: Conflict, *, truncate: bool = False) -> None:
    if conflict.source is None or not conflict.source.is_file() or not conflict.target.is_file():
        print("  Diff unavailable: both sides must be readable files.")
        return

    try:
        old_bytes = conflict.target.read_bytes()
        new_bytes = conflict.source.read_bytes()
        if b"\0" in old_bytes or b"\0" in new_bytes:
            print("  Diff unavailable: one or both files are binary.")
            return
        old_text = old_bytes.decode("utf-8")
        new_text = new_bytes.decode("utf-8")
    except (OSError, UnicodeDecodeError):
        print("  Diff unavailable: one or both files are not readable UTF-8 text.")
        return

    diff = list(
        difflib.unified_diff(
            old_text.splitlines(keepends=True),
            new_text.splitlines(keepends=True),
            fromfile=str(conflict.target),
            tofile=str(conflict.source),
        )
    )
    if not diff:
        print("  Files are text-identical.")
        return

    if truncate and len(diff) > MAX_DIFF_LINES:
        diff = diff[:MAX_DIFF_LINES] + ["... diff truncated ...\n"]
    print("".join(diff), end="" if diff[-1].endswith("\n") else "\n")


def conflict_from_output(
    line: str,
    stow_dir: Path,
    target_dir: Path,
    packages: Sequence[str],
) -> Conflict | None:
    match = CONFLICT_LINE.match(line)
    if match is not None:
        relative_path = Path(match.group(1))
        if relative_path.is_absolute() or ".." in relative_path.parts:
            raise RuntimeError(f"Stow reported an unsafe target path: {relative_path}")

        target = target_dir / relative_path
        sources = [stow_dir / package / relative_path for package in packages]
        source = next((candidate for candidate in sources if candidate.exists()), None)
        return Conflict(relative_path, target, source)

    match = DIRECTORY_CONFLICT_LINE.match(line)
    if match is None:
        return None

    source_path = Path(match.group(1))
    if not source_path.is_absolute():
        source_path = target_dir / source_path
    source_path = source_path.resolve()
    for package in packages:
        package_root = (stow_dir / package).resolve()
        try:
            relative_path = source_path.relative_to(package_root)
        except ValueError:
            continue
        return Conflict(relative_path, target_dir / relative_path, source_path)
    return None


def backup_path_for(target: Path) -> Path:
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    base = Path(f"{target}.stow-backup.{timestamp}")
    candidate = base
    suffix = 1
    while os.path.lexists(candidate):
        candidate = Path(f"{base}.{suffix}")
        suffix += 1
    return candidate


def effective_paths(
    stow_dir: Path,
    target_dir: Path,
    stow_options: Sequence[str],
) -> tuple[Path, Path]:
    stow_path = stow_dir.resolve()
    target_path = target_dir.resolve()
    index = 0
    while index < len(stow_options):
        option = stow_options[index]
        if option in ("-d", "--dir", "-t", "--target"):
            index += 1
            if index >= len(stow_options):
                raise RuntimeError(f"Stow option {option} requires a path.")
            value = stow_options[index]
            if option in ("-d", "--dir"):
                stow_path = Path(value).resolve()
            else:
                target_path = Path(value).resolve()
        elif option.startswith("--dir="):
            stow_path = Path(option.partition("=")[2]).resolve()
        elif option.startswith("--target="):
            target_path = Path(option.partition("=")[2]).resolve()
        elif option.startswith("-d") and len(option) > 2:
            stow_path = Path(option[2:]).resolve()
        elif option.startswith("-t") and len(option) > 2:
            target_path = Path(option[2:]).resolve()
        index += 1
    return stow_path, target_path


def apply_decision(conflict: Conflict, action: str) -> None:
    if not os.path.lexists(conflict.target):
        raise RuntimeError(f"Conflict disappeared before it could be resolved: {conflict.target}")

    if action == "backup":
        backup = backup_path_for(conflict.target)
        os.replace(conflict.target, backup)
        print(f"  Backed up {conflict.target} -> {backup}")
    elif action == "overwrite":
        if conflict.target.is_dir() and not conflict.target.is_symlink():
            try:
                conflict.target.rmdir()
            except OSError as error:
                raise RuntimeError(
                    f"Refusing to remove non-empty directory {conflict.target}; "
                    "choose backup instead."
                ) from error
        else:
            conflict.target.unlink()
        print(f"  Replacing {conflict.target} without a backup.")


def preview(conflict: Conflict) -> None:
    print(f"\nConflict: {conflict.target}")
    if conflict.source is None:
        print("  No matching source file was found in the selected packages.")
        return

    print(f"  Stow source: {conflict.source}")
    source_md5 = md5(conflict.source)
    target_md5 = md5(conflict.target)
    if source_md5 is not None and target_md5 is not None:
        if source_md5 == target_md5:
            print(f"  MD5 matches ({source_md5}); only the filesystem link differs.")
        else:
            print(f"  MD5 differs: target {target_md5}, source {source_md5}.")

    if source_md5 is None or target_md5 is None or source_md5 == target_md5:
        return

    try:
        old_size = conflict.target.stat().st_size
        new_size = conflict.source.stat().st_size
        if old_size + new_size > MAX_DIFF_BYTES:
            print("  Diff preview skipped (combined file size exceeds 16 KiB).")
            return
        diff = list(
            difflib.unified_diff(
                conflict.target.read_text(encoding="utf-8").splitlines(keepends=True),
                conflict.source.read_text(encoding="utf-8").splitlines(keepends=True),
                fromfile=str(conflict.target),
                tofile=str(conflict.source),
            )
        )
    except (OSError, UnicodeDecodeError):
        print("  Diff preview skipped (binary or unreadable file).")
        return

    if len(diff) <= MAX_DIFF_LINES:
        print("".join(diff), end="" if not diff or diff[-1].endswith("\n") else "\n")
    else:
        print("  Diff preview skipped (more than 100 lines; press d to show a truncated diff).")


def choose_action(conflict: Conflict) -> str:
    while True:
        answer = input(
            "  [b]ackup+replace (default), [o]verwrite, [d]iff, [m]d5, "
            "[B]ackup all remaining, [O]verwrite all remaining, [q]uit: "
        ).strip()
        if answer == "" or answer == "b":
            return "backup"
        if answer == "o":
            return "overwrite"
        if answer == "B":
            return "backup-all"
        if answer == "O":
            return "overwrite-all"
        if answer == "d":
            display_diff(conflict, truncate=True)
        elif answer == "m":
            print(f"  Target MD5: {md5(conflict.target) or 'unavailable'}")
            print(f"  Source MD5: {md5(conflict.source) if conflict.source else 'unavailable'}")
        elif answer == "q":
            raise RuntimeError("Conflict resolution cancelled; no targets were changed.")
        else:
            print("  Choose b, o, d, m, B, O, or q.")


def resolve_conflicts(
    conflicts: Sequence[Conflict],
    mode: str,
    *,
    interactive: bool,
) -> None:
    if not conflicts:
        return
    if mode == "fail":
        raise RuntimeError(
            "Stow conflicts found; no files were changed. Re-run with "
            "--conflicts prompt, backup, or overwrite."
        )
    if mode == "prompt" and not interactive:
        raise RuntimeError(
            "Stow conflicts found, but standard input is not a terminal. "
            "Choose --conflicts backup or --conflicts overwrite explicitly."
        )

    decisions: list[tuple[Conflict, str]] = []
    batch_action: str | None = None
    for conflict in conflicts:
        preview(conflict)
        if mode in ("backup", "overwrite"):
            action = mode
        elif batch_action is not None:
            action = batch_action
        else:
            action = choose_action(conflict)
            if action.endswith("-all"):
                batch_action = action.removesuffix("-all")
                action = batch_action

        if action == "overwrite" and conflict.target.is_dir() and not conflict.target.is_symlink():
            try:
                next(conflict.target.iterdir())
            except StopIteration:
                pass
            else:
                raise RuntimeError(
                    f"Refusing to overwrite non-empty directory {conflict.target}; "
                    "choose backup instead."
                )
        decisions.append((conflict, action))

    for conflict, action in decisions:
        apply_decision(conflict, action)


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stow-dir", type=Path, required=True)
    parser.add_argument("--target-dir", type=Path, required=True)
    parser.add_argument("--mode", choices=("prompt", "backup", "overwrite", "fail"), required=True)
    parser.add_argument("--ignore-regex", default=r"secrets\.vars")
    parser.add_argument("--stow-option", action="append", default=[])
    parser.add_argument("--package", action="append", default=[])
    args = parser.parse_args(argv)
    if not args.package:
        parser.error("at least one --package is required")

    try:
        stow_dir, target_dir = effective_paths(
            args.stow_dir,
            args.target_dir,
            args.stow_option,
        )
    except RuntimeError as error:
        print(f"Stow conflict resolver: {error}", file=sys.stderr)
        return 2

    command = [
        "stow",
        "-d",
        str(stow_dir),
        f"--target={target_dir}",
        "--no-folding",
        f"--ignore={args.ignore_regex}",
        "--simulate",
        "--verbose=2",
        *args.stow_option,
        *args.package,
    ]

    result = subprocess.run(command, text=True, capture_output=True, check=False)
    lines = result.stdout.splitlines() + result.stderr.splitlines()
    try:
        conflicts = []
        seen: set[Path] = set()
        for line in lines:
            conflict = conflict_from_output(line, stow_dir, target_dir, args.package)
            if conflict is not None and conflict.relative_path not in seen:
                seen.add(conflict.relative_path)
                conflicts.append(conflict)

        if result.returncode != 0 and not conflicts:
            sys.stderr.write(result.stdout)
            sys.stderr.write(result.stderr)
            return result.returncode

        resolve_conflicts(conflicts, args.mode, interactive=sys.stdin.isatty())
    except RuntimeError as error:
        print(f"Stow conflict resolver: {error}", file=sys.stderr)
        for line in lines:
            if (
                line.startswith("CONFLICT ")
                or DIRECTORY_CONFLICT_LINE.match(line)
                or line.startswith("WARNING!")
                or line == "All operations aborted."
            ):
                print(line, file=sys.stderr)
        return 1
    except OSError as error:
        print(f"Stow conflict resolver: {error}", file=sys.stderr)
        return 1

    if conflicts:
        print(f"Resolved {len(conflicts)} Stow conflict(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
