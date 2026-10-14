#!/usr/bin/env bash
# Needlestack initial source import. Run from a trusted machine with git credentials.
set -euo pipefail
ZIP="${1:-Needlestack_GitHub_Ready_M018.zip}"
if [[ ! -f "$ZIP" ]]; then echo "Archive not found: $ZIP" >&2; exit 1; fi
command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
command -v unzip >/dev/null || { echo "unzip is required" >&2; exit 1; }
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
git clone https://github.com/mtdewwolf/needlestack.git "$work/needlestack"
unzip -q "$ZIP" -d "$work/needlestack"
cd "$work/needlestack"
test -f Assets/HayGame/Runtime/MaterialWorld.cs
git add -A
if git diff --cached --quiet; then echo "No changes to commit."; exit 0; fi
git commit -m "Import Needlestack Unity prototype through milestone 018"
git push origin HEAD:Master
echo "Uploaded commit: $(git rev-parse HEAD)"
