#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ "$(tty)" = "/dev/tty1" ] && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
