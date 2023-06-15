(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
# Set the path to your .envrc file
envrc_file="$HOME/.envrc"

# Check if the .envrc file exists
if [[ -f "$envrc_file" ]]; then
  # Allow the .envrc file using direnv
  source "$envrc_file"
else
  echo "$envrc_file does not exist"
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# if [[ $__INTELLIJ_COMMAND_HISTFILE__ ]] then
# ZSH_THEME="robbyrussell"
#else
ZSH_THEME="powerlevel10k/powerlevel10k"
#fi
KUBECONFIG=$HOME/.kube/config


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# See: https://github.com/ohmyzsh/ohmyzsh/issues/6835
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git heroku gitfast bundler dotenv rake macos rbenv ruby asdf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

p10kcolors() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

export PROJECT_FOLDER="$HOME/workspace"

# Modifies the :Files command from fzf.vim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
source "$HOME/workspace/dotfiles/dotfiles/zshrc.include"

# This helps preserver history in Elixir's iex
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 2097152 -kernel shell_history_path '\"$HOME/.iex-history\"'"

export CLOUDSDK_PYTHON="$(brew --prefix)/opt/python@3.8/libexec/bin/python"

# Geometer
export GCP_ORGANIZATION_ID=717821974255
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
alias k="kubectl"

# Editor
alias vim="nvim"
alias vi="nvim"
alias vmerge="git mergetool -t vimdiff"
alias watch="watch "

# Kohort
alias bc="./run-test ./bin/checks.sh"
alias dcu="docker-compose up"
alias dcr="docker-compose restart"
alias dcd="docker-compose down"
alias ghprev="gh pr create --title 'Preview' --body 'Preview' --web"

# Misc
alias sshunsafe="ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\""
alias clearswap="sudo pkill -HUP -u _windowserver"
alias kctx="kubectl config current-context"

unfunction work_in_progress

function killall {
  for p in `ps aux | grep $1 | awk '{print $2}'`; do
    echo "Force killing $p"
    kill -9 $p
  done
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

. ~/.asdf/plugins/java/set-java-home.zsh
export PATH=/Users/oliverswitzer/.local/bin:$PATH
