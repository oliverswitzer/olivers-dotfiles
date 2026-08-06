# ── git worktree helpers ─────────────────────────────────────────
# Worktrees live under a global base, grouped by project name:
#   ~/.config/superpowers/worktrees/<project>/<branch>
# All commands run from anywhere inside a git repo; the repo root and
# project name are derived automatically. Commands that cd will drop
# into server/ if it exists, otherwise the worktree root.
#
# NOTE: wt/wtcd must be sourced (not bin/ scripts) because they cd the
# current shell — a child process can't change its parent's directory.
WT_BASE="$HOME/.config/superpowers/worktrees"

# wt <branch> — create (or reuse) a worktree and cd into it.
#   • If the worktree already exists, just cd in.
#   • If the branch exists locally or on origin, check it out.
#   • If the branch doesn't exist anywhere, create a new branch.
#   e.g.  wt ge-1206-fix-ci-i18n-mismatch-issue   (existing branch)
#         wt my-new-feature                        (new branch)
wt() {
  local branch="$1"
  [ -z "$branch" ] && { echo "usage: wt <branch>"; return 1; }
  local root proj path
  root=$(git rev-parse --show-toplevel) || return 1
  proj=$(basename "$root")
  path="$WT_BASE/$proj/$branch"
  if [ ! -d "$path" ]; then
    if git show-ref --verify --quiet "refs/heads/$branch" || \
       git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      git worktree add "$path" "$branch"     # existing branch
    else
      git worktree add "$path" -b "$branch"  # new branch
    fi
  fi
  [ -d "$path/server" ] && cd "$path/server" || cd "$path"
}

# wtcd <branch> — cd into an EXISTING worktree (creates nothing).
#   e.g.  wtcd ge-1206-fix-ci-i18n-mismatch-issue
wtcd() {
  [ -z "$1" ] && { echo "usage: wtcd <branch>"; return 1; }
  local root proj path
  root=$(git rev-parse --show-toplevel) || return 1
  proj=$(basename "$root")
  path="$WT_BASE/$proj/$1"
  [ -d "$path/server" ] && cd "$path/server" || cd "$path"
}

# wtrm <branch> — remove a worktree; the BRANCH is kept.
#   • Refuses if the worktree has uncommitted changes — to force:
#       git worktree remove --force <path>
#   • To also delete the branch afterward:
#       git branch -d <branch>   (-D to force-delete an unmerged branch)
#   e.g.  wtrm ge-1206-fix-ci-i18n-mismatch-issue
wtrm() {
  local branch="$1"
  [ -z "$branch" ] && { echo "usage: wtrm <branch>"; return 1; }
  local root proj path
  root=$(git rev-parse --show-toplevel) || return 1
  proj=$(basename "$root")
  path="$WT_BASE/$proj/$branch"
  git worktree remove "$path" && echo "Removed $path"
  git worktree prune
  echo "Branch '$branch' kept. Delete with: git branch -d $branch"
}

# wtls — list all worktrees for the current repo (branch + commit).
alias wtls='git worktree list'

# wthelp — print this command summary (reads the "# wt… —" lines below).
alias wthelp="grep -E '^# wt' ~/.config/zsh/rc.d/worktrees.zsh | sed 's/^# //'"
# ─────────────────────────────────────────────────────────────────
