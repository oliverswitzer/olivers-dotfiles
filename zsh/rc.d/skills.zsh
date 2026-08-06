# Sourced zsh helper functions for managing agent skills.
# Moved out of .zshrc into rc.d/ for modularity.

# dlskill: download a Zed agent skill directory from a GitHub tree URL.
# Usage: dlskill <github-tree-url-to-skill-dir> [target-dir]
# Example: dlskill https://github.com/netresearch/context7-skill/tree/main/skills/context7
# Defaults target-dir to ~/.agents/skills and installs using the source folder name.
dlskill() {
  local url="${1:-}"
  local target_dir="${2:-$HOME/.agents/skills}"

  if [[ -z "$url" || "$url" == "--help" || "$url" == "-h" ]]; then
    cat <<'HELP'
Usage:
  dlskill <github-tree-url-to-skill-dir> [target-dir]

Downloads a Zed agent skill directory from a GitHub tree URL.

Arguments:
  github-tree-url-to-skill-dir  URL to a skill directory in a GitHub repo.
                                The directory must contain SKILL.md.
  target-dir                    Optional install directory.
                                Defaults to ~/.agents/skills.

Example:
  dlskill https://github.com/netresearch/context7-skill/tree/main/skills/context7

Installs to:
  ~/.agents/skills/context7
HELP
    if [[ -z "$url" ]]; then
      return 2
    fi
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "dlskill: git is required" >&2
    return 1
  fi

  url="${url%%#*}"
  url="${url%%\?*}"
  url="${url%/}"

  local parts owner repo branch skill_path folder_name target tmpdir src
  parts=(${(s:/:)url})

  if [[ "${parts[1]}" != "https:" || "${parts[2]}" != "github.com" || "${parts[5]}" != "tree" || ${#parts[@]} -lt 7 ]]; then
    echo "dlskill: expected a GitHub tree URL like:" >&2
    echo "  https://github.com/OWNER/REPO/tree/BRANCH/path/to/skill" >&2
    return 2
  fi

  owner="${parts[3]}"
  repo="${parts[4]%.git}"
  branch="${parts[6]}"
  skill_path="${(j:/:)parts[7,-1]}"
  folder_name="${parts[-1]}"
  target="${target_dir%/}/$folder_name"

  if [[ -z "$skill_path" ]]; then
    echo "dlskill: URL must point to a skill directory inside the repo" >&2
    return 2
  fi

  if [[ -e "$target" ]]; then
    echo "dlskill: destination already exists: $target" >&2
    return 1
  fi

  tmpdir="$(mktemp -d)" || return 1

  echo "dlskill: fetching $owner/$repo:$branch/$skill_path"

  if ! git clone --depth 1 --filter=blob:none --sparse --branch "$branch" "https://github.com/$owner/$repo.git" "$tmpdir/repo" >/dev/null 2>&1; then
    echo "dlskill: failed to clone https://github.com/$owner/$repo.git branch $branch" >&2
    rm -rf "$tmpdir"
    return 1
  fi

  if ! git -C "$tmpdir/repo" sparse-checkout set -- "$skill_path" >/dev/null 2>&1; then
    echo "dlskill: path does not exist in repo: $skill_path" >&2
    rm -rf "$tmpdir"
    return 1
  fi

  src="$tmpdir/repo/$skill_path"
  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "dlskill: not a valid skill directory; missing SKILL.md at $skill_path/SKILL.md" >&2
    rm -rf "$tmpdir"
    return 1
  fi

  mkdir -p "$target_dir" || {
    rm -rf "$tmpdir"
    return 1
  }

  cp -R "$src" "$target_dir/" || {
    rm -rf "$tmpdir"
    return 1
  }

  rm -rf "$tmpdir"
  echo "dlskill: installed $folder_name to $target"
}
