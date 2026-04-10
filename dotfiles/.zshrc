
# The following lines were added by compinstall

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/shyam/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt extendedglob
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

# ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

####
# Prompt
####

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats ' %F{blue}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'

setopt PROMPT_SUBST
PROMPT='%B%F{green}%~%f${vcs_info_msg_0_} %F{white}❯%f%b '

####
# Aliases
####
alias edit-in-kitty='kitten edit-in-kitty'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

####
# Add things to PATH
####

# add bob to path
BOB_PATH="/home/shyam/.local/share/bob"
if [ -d "$BOB_PATH" ]; then
  export PATH="$BOB_PATH/nvim-bin:$PATH"
  source "$BOB_PATH/env/env.sh"
fi

# fnm
FNM_PATH="/home/shyam/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell bash)"
fi

# pnpm
export PNPM_HOME="/home/shyam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
