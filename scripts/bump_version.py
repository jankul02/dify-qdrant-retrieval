#!/usr/bin/env python3
"""Bump plugin version, update CHANGELOG, and commit.

Usage: python scripts/bump_version.py patch|minor|major

After merging to main, run 'make tag' to create the git tag.
"""
import re
import subprocess
import sys
from datetime import date
from pathlib import Path

ROOT = Path(__file__).parent.parent
MANIFEST = ROOT / "manifest.yaml"
CHANGELOG = ROOT / "CHANGELOG.md"


def read_version() -> str:
    for line in MANIFEST.read_text().splitlines():
        m = re.match(r"^version:\s*(\S+)", line)
        if m:
            return m.group(1)
    raise ValueError("version not found in manifest.yaml")


def bump(version: str, part: str) -> str:
    major, minor, patch = map(int, version.split("."))
    if part == "major":
        return f"{major + 1}.0.0"
    if part == "minor":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def update_manifest(old: str, new: str) -> None:
    text = MANIFEST.read_text()
    # Top-level version field
    text = re.sub(
        rf"^version: {re.escape(old)}$",
        f"version: {new}",
        text,
        flags=re.MULTILINE,
    )
    # meta.version field (indented by 2 spaces)
    text = re.sub(
        rf"^  version: {re.escape(old)}$",
        f"  version: {new}",
        text,
        flags=re.MULTILINE,
    )
    MANIFEST.write_text(text)


def update_changelog(new_version: str) -> None:
    today = date.today().isoformat()
    text = CHANGELOG.read_text()
    if f"## [{new_version}]" in text:
        print(f"⚠ CHANGELOG already has [{new_version}] — skipping changelog update.")
        return
    text = text.replace(
        "## [Unreleased]",
        f"## [Unreleased]\n\n## [{new_version}] - {today}",
        1,
    )
    CHANGELOG.write_text(text)


def run(*cmd: str) -> None:
    subprocess.run(cmd, check=True, cwd=ROOT)


def main() -> None:
    if len(sys.argv) != 2 or sys.argv[1] not in ("patch", "minor", "major"):
        print("Usage: bump_version.py patch|minor|major")
        sys.exit(1)

    part = sys.argv[1]
    old = read_version()
    new = bump(old, part)

    print(f"Bumping {old} → {new}")
    update_manifest(old, new)
    update_changelog(new)

    run("git", "add", str(MANIFEST), str(CHANGELOG))
    run("git", "commit", "-m", f"chore: bump version to {new}")
    run("git", "tag", f"v{new}")
    run("git", "push", "origin", f"v{new}")
    print(f"✓ Version bumped to {new} and tag v{new} pushed.")


if __name__ == "__main__":
    main()
