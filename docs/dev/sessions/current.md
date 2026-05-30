# Current Session

**Status:** Closed

<!-- This file is overwritten at each !start. -->

| Field | Value |
|-------|-------|
| Branch | session/2026-05-30-plugin-versioning |
| Goal | Plugin versioning |
| Started | 2026-05-30 |
| Outcome | Done — semver workflow added: `version.py` reads `__version__` from `manifest.yaml`; `scripts/bump_version.py` bumps version, updates CHANGELOG, commits, creates and pushes git tag; `make bump-patch/minor/major` targets added; `CHANGELOG.md` created; `manifest.yaml` bumped to `0.1.0`; both endpoints return `plugin_version` in success responses; `docs/dev/howtos.md` updated with release workflow |
