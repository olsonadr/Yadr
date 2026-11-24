import errno
import hashlib
import os
import pty
import select
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
RESOLVER = REPO_ROOT / "scripts" / "stow_conflicts.py"


class StowConflictTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.stow_dir = self.root / "stow"
        self.package = self.stow_dir / "test" / ".config" / "sample.conf"
        self.target_dir = self.root / "target"
        self.target = self.target_dir / ".config" / "sample.conf"
        self.package.parent.mkdir(parents=True)
        self.target.parent.mkdir(parents=True)
        self.package.write_text("package value\n", encoding="utf-8")
        self.target.write_text("local value\n", encoding="utf-8")

    def tearDown(self):
        self.temp_dir.cleanup()

    def run_resolver(self, mode):
        return subprocess.run(self.resolver_command(mode), text=True, capture_output=True, check=False)

    def resolver_command(self, mode):
        return [
            sys.executable,
            str(RESOLVER),
            "--stow-dir",
            str(self.stow_dir),
            "--target-dir",
            str(self.target_dir),
            "--mode",
            mode,
            "--package",
            "test",
        ]

    def run_interactive_resolver(self, answers):
        master, slave = pty.openpty()
        process = subprocess.Popen(
            self.resolver_command("prompt"),
            stdin=slave,
            stdout=slave,
            stderr=slave,
            close_fds=True,
        )
        os.close(slave)
        os.write(master, answers)
        output = bytearray()
        while process.poll() is None:
            readable, _, _ = select.select([master], [], [], 0.1)
            if readable:
                try:
                    output.extend(os.read(master, 65536))
                except OSError as error:
                    if error.errno != errno.EIO:
                        raise
                    break
        while True:
            try:
                output.extend(os.read(master, 65536))
            except OSError as error:
                if error.errno == errno.EIO:
                    break
                raise
        os.close(master)
        return process.wait(timeout=5), output.decode("utf-8", errors="replace")

    def run_noninteractive_prompt(self):
        return subprocess.run(
            self.resolver_command("prompt"),
            text=True,
            capture_output=True,
            check=False,
        )

    def run_stow_script(self, mode):
        wrapper = self.root / "wrapper"
        wrapper.mkdir(exist_ok=True)
        (wrapper / "scripts").mkdir(exist_ok=True)
        shutil.copy2(REPO_ROOT / "stow_dots.sh", wrapper / "stow_dots.sh")
        shutil.copy2(RESOLVER, wrapper / "scripts" / "stow_conflicts.py")
        (wrapper / "stow").mkdir(exist_ok=True)
        shutil.copytree(self.package.parents[1], wrapper / "stow" / "test")
        (wrapper / "config.sh").write_text(
            "\n".join(
                [
                    f'CFG_STOW_TARGET="{self.target_dir}"',
                    'CFG_STOW_DEFAULT="exclude"',
                    'CFG_STOW_INCLUDE=("test")',
                    "CFG_STOW_EXCLUDE=()",
                    "CFG_STOW_IGNORE=()",
                    "CFG_MIRROR_ENABLED=false",
                    'CFG_PRIVATE_DIR=""',
                    "CFG_PRIVATE_INCLUDE=()",
                    "CFG_PRIVATE_EXCLUDE=()",
                    'CFG_SECRETS_FILE=""',
                    'CFG_SECRETS_TRACKED_FILE=""',
                    "CFG_COMBINE_ENABLED=false",
                ]
            )
            + "\n",
            encoding="utf-8",
        )
        return subprocess.run(
            ["bash", str(wrapper / "stow_dots.sh"), "--no-mirror", "--conflicts", mode],
            text=True,
            capture_output=True,
            check=False,
        )

    def stow_package(self):
        subprocess.run(
            [
                "stow",
                "-d",
                str(self.stow_dir),
                "-t",
                str(self.target_dir),
                "--no-folding",
                "test",
            ],
            check=True,
            capture_output=True,
            text=True,
        )

    def test_backup_mode_preserves_conflicting_file_then_allows_stow(self):
        result = self.run_resolver("backup")
        self.assertEqual(result.returncode, 0, result.stderr)
        backups = list(self.target.parent.glob("sample.conf.stow-backup.*"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(encoding="utf-8"), "local value\n")

        self.stow_package()
        self.assertTrue(self.target.is_symlink())
        self.assertEqual(self.target.resolve(), self.package)

    def test_stow_dots_script_backs_up_before_applying_links(self):
        result = self.run_stow_script("backup")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        backups = list(self.target.parent.glob("sample.conf.stow-backup.*"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(encoding="utf-8"), "local value\n")
        self.assertTrue(self.target.is_symlink())
        self.assertEqual(self.target.resolve(), self.root / "wrapper/stow/test/.config/sample.conf")

    def test_overwrite_mode_reports_diff_and_replaces_without_backup(self):
        result = self.run_resolver("overwrite")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("MD5 differs", result.stdout)
        self.assertIn("-local value", result.stdout)
        self.assertFalse(self.target.exists())
        self.assertFalse(list(self.target.parent.glob("*.stow-backup.*")))

        self.stow_package()
        self.assertTrue(self.target.is_symlink())

    def test_fail_mode_leaves_conflicting_file_untouched(self):
        result = self.run_resolver("fail")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("--conflicts prompt, backup, or overwrite", result.stderr)
        self.assertEqual(self.target.read_text(encoding="utf-8"), "local value\n")

    def test_interactive_prompt_supports_diff_checksum_and_overwrite(self):
        returncode, output = self.run_interactive_resolver(b"d\nm\no\n")
        self.assertEqual(returncode, 0, output)
        self.assertIn("--- ", output)
        self.assertIn("Target MD5:", output)
        self.assertIn("Replacing ", output)
        self.assertFalse(self.target.exists())

    def test_interactive_backup_all_applies_to_remaining_conflicts(self):
        second_package = self.package.parent / "other.conf"
        second_target = self.target.parent / "other.conf"
        second_package.write_text("second package\n", encoding="utf-8")
        second_target.write_text("second local\n", encoding="utf-8")
        returncode, output = self.run_interactive_resolver(b"B\n")
        self.assertEqual(returncode, 0, output)
        self.assertIn("Resolved 2 Stow conflict(s).", output)
        self.assertFalse(self.target.exists())
        self.assertFalse(second_target.exists())
        self.assertEqual(
            len(list(self.target.parent.glob("*.stow-backup.*"))),
            2,
        )

    def test_noninteractive_prompt_fails_without_changing_target(self):
        result = self.run_noninteractive_prompt()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("standard input is not a terminal", result.stderr)
        self.assertEqual(self.target.read_text(encoding="utf-8"), "local value\n")

    def test_identical_contents_are_reported_by_md5(self):
        self.target.write_bytes(self.package.read_bytes())
        result = self.run_resolver("backup")
        self.assertEqual(result.returncode, 0, result.stderr)
        digest = hashlib.md5(self.package.read_bytes()).hexdigest()
        self.assertIn(f"MD5 matches ({digest})", result.stdout)

    def test_nonempty_directory_requires_backup(self):
        self.target.unlink()
        self.target.mkdir()
        (self.target / "keep.txt").write_text("keep\n", encoding="utf-8")
        result = self.run_resolver("overwrite")
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue((self.target / "keep.txt").exists())

        result = self.run_resolver("backup")
        self.assertEqual(result.returncode, 0, result.stderr)
        backups = list(self.target.parent.glob("sample.conf.stow-backup.*"))
        self.assertEqual(len(backups), 1)
        self.assertEqual((backups[0] / "keep.txt").read_text(encoding="utf-8"), "keep\n")

    def test_no_conflict_is_a_no_op(self):
        self.target.unlink()
        result = self.run_resolver("prompt")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.target.exists())


if __name__ == "__main__":
    unittest.main()
