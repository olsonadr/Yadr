#!/usr/bin/env python3
"""Merge per-package secrets.vars manifests into one user secrets file.

Usage: merge_secrets.py SECRETS_FILE MANIFEST [MANIFEST ...]

Manifest line format (one variable per line, '#' starts a comment):
    VAR          required variable
    ?VAR         optional variable (never warned about)
Existing values in SECRETS_FILE are never removed or changed. Missing
variables are appended as empty assignments (commented out for optional ones)
and each missing REQUIRED one is reported on stderr. Exit code is always 0.
"""
import os
import re
import sys

ASSIGN = re.compile(r"^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)=(.*)$")


def parse_manifest(path):
    out = []
    for raw in open(path, encoding="utf-8"):
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        optional = line.startswith("?")
        name = line.lstrip("?").strip().split()[0]
        desc = raw.split("#", 1)[1].strip() if "#" in raw else ""
        out.append((name, optional, desc))
    return out


def main(argv):
    if len(argv) < 3:
        print(__doc__)
        return 1
    secrets, manifests = argv[1], argv[2:]
    text = open(secrets, encoding="utf-8").read() if os.path.exists(secrets) else ""
    have = {}
    for line in text.splitlines():
        m = ASSIGN.match(line)
        if m:
            have[m.group(1)] = m.group(2).strip().strip("'\"")
    # a commented placeholder such as "# VAR=" also counts as already listed
    listed = set(have) | set(re.findall(r"^#\s*([A-Za-z_][A-Za-z0-9_]*)=", text, re.M))
    add, missing = [], []
    for mf in manifests:
        pkg = os.path.basename(os.path.dirname(os.path.abspath(mf)))
        for name, optional, desc in parse_manifest(mf):
            if name not in listed:
                suffix = "  # " + desc if desc else ""
                prefix = "# " if optional else ""
                add.append("%s%s=%s" % (prefix, name, suffix))
                listed.add(name)
            if not optional and not have.get(name):
                missing.append((name, pkg, desc))
    if add or not os.path.exists(secrets):
        os.makedirs(os.path.dirname(os.path.abspath(secrets)), exist_ok=True)
        with open(secrets, "a", encoding="utf-8") as f:
            if not text:
                f.write("# dots secrets: shell syntax, sourced by ~/.shell_rcs. Never overwritten.\n")
            elif not text.endswith("\n"):
                f.write("\n")
            f.write("\n".join(add) + ("\n" if add else ""))
        os.chmod(secrets, 0o600)
    for name, pkg, desc in missing:
        print("WARNING: secret %s is required by '%s' but not set in %s%s"
              % (name, pkg, secrets, " (" + desc + ")" if desc else ""), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
