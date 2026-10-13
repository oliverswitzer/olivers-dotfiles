# launchd agents + t7run

Everything in `~/workspace` lives on the external Samsung T7 (`/Volumes/Macmini Storage`,
`~/workspace` is a symlink to it). macOS treats it as an external volume, so a
LaunchAgent can only read/write it if the process launchd starts has Full Disk Access.

## The problem this solves
- launchd itself can't use T7 paths for `WorkingDirectory` / `StandardOutPath` /
  `StandardErrorPath` -> spawn fails with `posix_spawn ... Operation not permitted` (exit 78).
- `/bin/bash`, asdf node, etc. have no Full Disk Access -> "Operation not permitted" reading scripts.
- Granting FDA per runtime (python, node...) breaks whenever brew/asdf upgrades the binary.

## The fix
`t7run` is a ~30 line C launcher in `~/bin/t7run` (internal disk). Every agent runs
`t7run /bin/bash -c 'cd <project> && exec <cmd>'`. t7run *spawns* the child (doesn't exec),
so it stays the TCC "responsible process" and everything under it inherits its Full Disk
Access. One grant covers every agent, and nothing else on the Mac gets broader access.

Rules for every plist in `agents/`:
1. `ProgramArguments[0]` = `/Users/clawliver/bin/t7run`
2. No `WorkingDirectory`; `cd` inside the `bash -c` string instead
3. Logs go to `~/Library/Logs/<label>.{out,err}.log`, never the T7

## Install / update
```
./launchd/install.sh
```
Builds + ad-hoc signs t7run (identifier `com.oliverswitzer.t7run`), copies plists into
`~/Library/LaunchAgents` (copied, not symlinked: this repo is on the T7), and prints the
reload commands.

First time, or whenever t7run is rebuilt (the script tells you): System Settings >
Privacy & Security > Full Disk Access > + > `~/bin/t7run` (Cmd+Shift+G to type the path).
The grant is tied to the binary's signature, so an unchanged rebuild keeps it.

Hermes cannot run `launchctl bootstrap` from inside its gateway, so reloads are run by hand.

## Adding a new agent
Copy an existing plist in `agents/`, change Label + the `bash -c` command, run `install.sh`,
then the printed reload command. Edit plists here, not in `~/Library/LaunchAgents`.

## Debugging
- `launchctl print gui/$(id -u)/<label> | grep -E "state|last exit"`
- `log show --last 5m --predicate 'process == "launchd" AND eventMessage CONTAINS "<label>"'`
- `tail ~/Library/Logs/<label>.err.log`
