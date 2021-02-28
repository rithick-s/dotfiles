#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
dbus-run-session pulseaudio --daemon
exec xmonad
