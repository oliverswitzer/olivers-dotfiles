#!/bin/bash
# Build + sign t7run into ~/bin, and copy agent plists into ~/Library/LaunchAgents.
# Safe to re-run. Normally invoked by mac-mini/setup.sh. See mac-mini/README.md.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/bin/t7run"
ID="com.oliverswitzer.t7run"
mkdir -p "$HOME/bin" "$HOME/Library/Logs"

TMP="$(mktemp -d)"
clang -O2 -Wall -o "$TMP/t7run" "$HERE/t7run/t7run.c"
codesign -s - -i "$ID" -f "$TMP/t7run"
if [ -f "$BIN" ] && cmp -s "$TMP/t7run" "$BIN"; then
  echo "t7run unchanged (existing Full Disk Access grant still valid)"
else
  install -m 755 "$TMP/t7run" "$BIN"
  echo "t7run (re)built at $BIN"
  echo ">> Grant/re-grant Full Disk Access: System Settings > Privacy & Security > Full Disk Access > + > $BIN"
fi
rm -rf "$TMP"

# Plists are COPIED, not symlinked: this repo lives on the T7 and launchd
# cannot read plists through a symlink onto the external volume.
for p in "$HERE"/agents/*.plist; do
  plutil -lint -s "$p"
  cp "$p" "$HOME/Library/LaunchAgents/"
  echo "installed $(basename "$p")"
done

echo
echo "Reload (run in your own Terminal):"
for p in "$HERE"/agents/*.plist; do
  l="$(basename "$p" .plist)"
  echo "  launchctl bootout gui/\$(id -u)/$l 2>/dev/null; launchctl bootstrap gui/\$(id -u) ~/Library/LaunchAgents/$l.plist"
done
