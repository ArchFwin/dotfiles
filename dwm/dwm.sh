#!/bin/sh
# Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
# DWM startup file.
# Obviously, dwm must be started. Starts first to ensure usable desktop if something later is broken, and exits the script if it doesn't run properly.
dwm || return 1 &

# Autostart Section
transmission-gtk -m &
pidgin &
claws-mail &
dropboxd &
SpiderOak &
start-pulseaudio-x11 &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
export {SSH_AUTH_SOCK,GPG_AGENT_INFO,GNOME_KEYRING_CONTROL,GNOME_KEYRING_PID} &

# Power Management Script
/home/andrew/scripts/bat.sh &

# Configuration Section
setxkbmap gb
feh --bg-scale /home/andrew/Pictures/GITS_Laughing_Man_wall_02_by_pansejra.jpg
conky | while read -r; do xsetroot -name "$REPLY"; done &
/home/andrew/scripts/redshift &

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep -secure&

#I like nm-applet to be as close to the time as possible. This helps ensure that happens.
sleep 30s
nm-applet
