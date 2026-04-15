#
# ~/.zprofile
#

export ELECTRON_PASSWORD_STORE=gnome-libsecret

if [ "$(tty)" = "/dev/tty1" ] && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
