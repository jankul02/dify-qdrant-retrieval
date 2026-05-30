import re
from pathlib import Path


def _read_version() -> str:
    manifest = Path(__file__).parent / "manifest.yaml"
    for line in manifest.read_text().splitlines():
        m = re.match(r"^version:\s*(\S+)", line)
        if m:
            return m.group(1)
    return "0.0.0"


__version__ = _read_version()
