#!/bin/bash
# mac-mini/setup.sh: Mac mini ONLY (the always-on Hermes / services box).
# Do not run on a laptop. The top-level ../setup.sh is the general dotfiles setup;
# this script layers on the Mac-mini-specific pieces. Safe to re-run.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
EXPECTED_HOST="Clawlivers-Mac-mini"

host="$(scutil --get LocalHostName 2>/dev/null || true)"
if [ "$host" != "$EXPECTED_HOST" ] && [ "${FORCE_MAC_MINI:-}" != "1" ]; then
  echo "Refusing to run: this is '$host', not '$EXPECTED_HOST'." >&2
  echo "This script is for the Mac mini only. Override with FORCE_MAC_MINI=1 if you really mean it." >&2
  exit 1
fi
if [ "$(id -u)" = "0" ]; then
  echo "Run as your normal user, not sudo (LaunchAgents and ~/bin are per-user)." >&2
  exit 1
fi

echo "== LaunchAgents + t7run"
"$HERE/launchd/install.sh"
