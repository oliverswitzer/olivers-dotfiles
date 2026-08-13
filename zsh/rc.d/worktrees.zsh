# ── git worktree helpers ─────────────────────────────────────────
# New worktrees are created under a global base, grouped by project:
#   ~/.config/superpowers/worktrees/<project>/<branch>
# But these commands are LOCATION-AGNOSTIC for existing worktrees:
# if a branch already has a worktree anywhere (e.g. Zed's agent puts
# them in <repo>/tmp/), they follow the branch to wherever it lives.
#
# All commands run from anywhere inside a git repo — including from
# inside another worktree. Commands that cd drop into server/ if it
# exists, otherwise the worktree root.
#
# NOTE: wt/wtcd must be sourced (not bin/ scripts) because they cd the
# current shell — a child process can't change its parent's directory.
# NOTE: never name a local var `path` in zsh — it's tied to $PATH and
# would blank out PATH inside the function. We use `dir` instead.
WT_BASE="$HOME/.config/superpowers/worktrees"

# _wt_proj — echo the project name (basename of the MAIN repo root).
# Uses --git-common-dir so it's correct even from inside a worktree.
_wt_proj() {
  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
    || { echo "not inside a git repo" >&2; return 1; }
  basename "$(dirname "$common")"
}

# _wt_find <branch> — echo the path of an existing worktree checked out
# on <branch>, wherever it lives. Empty output if none exists.
_wt_find() {
  git worktree list --porcelain | awk -v b="refs/heads/$1" '
    /^worktree /{p=substr($0, 10)}
    /^branch /{if (substr($0, 8)==b){print p; exit}}
  '
}

# _wt_enter <dir> — cd into a worktree, preferring its server/ subdir.
_wt_enter() { [ -d "$1/server" ] && cd "$1/server" || cd "$1"; }

# wt <branch> — go to the branch's worktree, creating one if needed.
#   • If a worktree for <branch> already exists ANYWHERE, cd into it.
#   • Else create it under the global base, then cd in.
#     - existing branch (local or origin) → checked out
#     - unknown branch                     → new branch created
#   e.g.  wt ge-1206-fix-ci-i18n-mismatch-issue
#         wt my-new-feature
wt() {
  local branch="$1"
  [ -z "$branch" ] && { echo "usage: wt <branch>"; return 1; }
  local proj dir existing
  existing=$(_wt_find "$branch")
  if [ -n "$existing" ]; then
    _wt_enter "$existing"; return
  fi
  proj=$(_wt_proj) || return 1
  dir="$WT_BASE/$proj/$branch"
  if git show-ref --verify --quiet "refs/heads/$branch" || \
     git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git worktree add "$dir" "$branch" || return 1     # existing branch
  else
    git worktree add "$dir" -b "$branch" || return 1  # new branch
  fi
  _wt_enter "$dir"
}

# wtcd <branch> — cd into an EXISTING worktree, wherever it lives.
#   e.g.  wtcd fix-grype-cosign-install   (even if Zed put it in tmp/)
wtcd() {
  [ -z "$1" ] && { echo "usage: wtcd <branch>"; return 1; }
  local dir
  dir=$(_wt_find "$1")
  [ -z "$dir" ] && { echo "wtcd: no worktree checked out on '$1'" >&2; return 1; }
  _wt_enter "$dir"
}

# wtrm <branch> — remove the branch's worktree (wherever it lives).
#   • The BRANCH is kept.
#   • Refuses if the worktree has uncommitted changes — to force:
#       git worktree remove --force <path>
#   • To also delete the branch afterward:
#       git branch -d <branch>   (-D to force-delete an unmerged branch)
#   e.g.  wtrm fix-grype-cosign-install
wtrm() {
  local branch="$1"
  [ -z "$branch" ] && { echo "usage: wtrm <branch>"; return 1; }
  local dir
  dir=$(_wt_find "$branch")
  [ -z "$dir" ] && { echo "wtrm: no worktree checked out on '$branch'" >&2; return 1; }
  git worktree remove "$dir" && echo "Removed $dir"
  git worktree prune
  echo "Branch '$branch' kept. Delete with: git branch -d $branch"
}

# wtls — list all worktrees for the current repo (branch + commit).
alias wtls='git worktree list'

# wthelp — print this command summary (reads the "# wt… —" lines below).
alias wthelp="grep -E '^# wt' ~/.config/zsh/rc.d/worktrees.zsh | sed 's/^# //'"
# ─────────────────────────────────────────────────────────────────
