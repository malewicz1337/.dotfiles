# =============================================================================
# P10K INSTANT PROMPT 
# =============================================================================
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# =============================================================================
# PATH & ENVIRONMENT VARIABLES
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

typeset -U PATH path
path=(
  "$HOME/.dotnet/tools"
  $path
)
export PATH
[ -f "/Users/malewicz/.ghcup/env" ] && . "/Users/malewicz/.ghcup/env" 

# =============================================================================
# OH-MY-ZSH CONFIGURATION
# =============================================================================
# ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto
zstyle ':omz:ZSH_COMPDUMP' use-cache yes

COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

fpath=(
  /Users/malewicz/.docker/completions 
  ${ASDF_DATA_DIR:-$HOME/.asdf}/completions 
  $fpath
)

plugins=(
  git 
  asdf 
  zsh-autosuggestions 
  zsh-syntax-highlighting
) 

source $ZSH/oh-my-zsh.sh

# =============================================================================
# TOOL INITIALIZATION
# =============================================================================
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if (( $+commands[go] )); then
  path=("$(go env GOBIN)" $path)
fi

if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
if (( $+commands[carapace] )); then
  source <(carapace _carapace)
fi

# =============================================================================
# VARIABLES & IGNORE PATTERNS 
# =============================================================================
EZA_IGNORE="node_modules|.git|.venv|__pycache__|.DS_Store|target|build|dist|bin|obj|.idea|.vscode|*.dll|*.exe|*.pdb|*.so|*.o|*.class|*.jar"

# =============================================================================
# FZF CONFIGURATION
# =============================================================================
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
  
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --ignore-glob=\"$EZA_IGNORE\" {} | head -200'"

  [ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

  _fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
  _fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }

  _fzf_comprun() {
    local command=$1
    shift
    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always --ignore-glob=\"$EZA_IGNORE\" {} | head -200' "$@" ;;
      export|unset) fzf --preview "eval 'echo \$'{}"           "$@" ;;
      ssh)          fzf --preview 'dig {}'                     "$@" ;;
      *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
  }
fi

# =============================================================================
# ALIASES & EDITOR
# =============================================================================
set -o vi

alias gu="gh browse"
alias code="codium"
alias python="python3"
alias pip="pip3"
alias vim="nvim"
alias cat="bat"

alias ls="eza --color=always --git --icons=always --no-filesize --no-time --no-user --no-permissions"
alias ll="eza --color=always --git --icons=always --long"
alias la="eza --color=always --git --icons=always --long --all"
# alias tree="eza --tree --color=always --icons=always --ignore-glob=\"$EZA_IGNORE\""
unalias tree 2>/dev/null
function tree() {
  local depth="3"
  
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    depth="--level=$1"
    shift 
  fi

  eza --tree $depth --color=always --icons=always --ignore-glob="$EZA_IGNORE" "$@"
}

alias docker-nuke='docker system prune -a --volumes -f && docker builder prune -a -f && docker volume prune -a -f'

brave-ru() {
  open -na "Brave Browser" --args --user-data-dir="/tmp/brave-ru" --lang=ru --accept-lang=ru-RU,ru "$@"
}

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey ' ' magic-space

function copy-buffer-to-clipboard() {
  echo -n "$BUFFER" | pbcopy
  zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey '^Xc' copy-buffer-to-clipboard

# =============================================================================
# THEME & CONFIG
# =============================================================================
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

