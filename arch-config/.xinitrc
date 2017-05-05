#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb ~/.Xresources

case "${1}" in
*)
  export EDITOR=vim
  exec dbus-launch --exit-with-session i3
;;
esac

/usr/bin/VBoxClient-all
