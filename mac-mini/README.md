# mac-mini

Config that only applies to the Mac mini (`Clawlivers-Mac-mini`), the always-on box
that runs the Hermes gateway and the long-running local services. Nothing in here
should be installed on a laptop.

```
./mac-mini/setup.sh
```
Run as your normal user (not sudo). It refuses to run on any other host unless
`FORCE_MAC_MINI=1` is set. Safe to re-run. The top-level `setup.sh` is still the
general dotfiles setup; run that first on a fresh machine.

## Layout
```
mac-mini/
  setup.sh                 entry point, Mac mini only
  launchd/
    install.sh             builds t7run, installs agent plists
    t7run/t7run.c          the launcher (see below)
    agents/*.plist         LaunchAgents for services that live on the T7
```

## Why: the T7 external drive
`~/workspace` is a symlink to `/Volumes/Macmini Storage/workspace`, an external
Samsung T7. macOS treats it as an external volume, so a LaunchAgent can only read or
write it if the process launchd starts has Full Disk Access. Without that:
- launchd can't use T7 paths for `WorkingDirectory` / `StandardOutPath` /
  `StandardErrorPath`, and the spawn fails with `posix_spawn ... Operation not permitted`
  (launchctl shows `last exit code = 78: EX_CONFIG`).
- `/bin/bash`, asdf node, etc. have no Full Disk Access, so they get
  "Operation not permitted" opening scripts on the T7.
- Granting Full Disk Access per runtime (python, node...) breaks whenever brew/asdf
  upgrades the binary, because the grant is tied to that exact file.

## t7run
A ~30 line C launcher installed at `~/bin/t7run` (internal disk). Every agent runs
`t7run /bin/bash -c 'cd <project> && exec <cmd>'`. t7run spawns the child rather than
exec'ing it, so it stays the macOS "responsible process" and everything underneath
inherits its Full Disk Access. One grant covers every agent, and nothing else on the
machine gets broader access.

Grant it once (and again only if setup says t7run was rebuilt):
System Settings > Privacy & Security > Full Disk Access > + > `~/bin/t7run`
(Cmd+Shift+G to type the path). It's ad-hoc signed as `com.oliverswitzer.t7run`;
an unchanged rebuild keeps the existing grant.

## LaunchAgent rules
Every plist in `launchd/agents/`:
1. `ProgramArguments[0]` is `/Users/clawliver/bin/t7run`
2. No `WorkingDirectory`; `cd` inside the `bash -c` string instead
3. Logs go to `~/Library/Logs/<label>.{out,err}.log`, never the T7

Plists are copied into `~/Library/LaunchAgents`, not symlinked, because this repo
also lives on the T7. Edit them here, then re-run `setup.sh`.

Current agents: `com.pr-review-reports.server`, `com.reddit-bot.discord`,
`com.travel-planning.serve`. Starnet was intentionally retired (Oct 2026).

## Reloading
setup.sh prints the reload commands. Hermes can't run `launchctl bootstrap` from
inside its gateway, so run them yourself in Terminal:
```
for l in com.pr-review-reports.server com.reddit-bot.discord com.travel-planning.serve; do
  launchctl bootout gui/$(id -u)/$l 2>/dev/null
  sleep 2   # bootout is async; bootstrapping too soon fails silently
  launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/$l.plist
done
```

## Adding a new agent
Copy an existing plist in `launchd/agents/`, change `Label` and the `bash -c` command,
run `./mac-mini/setup.sh`, then the printed reload command.

## Debugging
- `launchctl print gui/$(id -u)/<label> | grep -E "state|last exit"`
- `log show --last 5m --predicate 'process == "launchd" AND eventMessage CONTAINS "<label>"'`
- `tail ~/Library/Logs/<label>.err.log`
