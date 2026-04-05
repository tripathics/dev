#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# defaults
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
# end defaults

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ -f ~/.config/bash/keybindings.sh ]] && source ~/.config/bash/keybindings.sh

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

