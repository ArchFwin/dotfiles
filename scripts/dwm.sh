
#!/bin/sh
# Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
# DWM startup file.

# Autostart Section
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
feh --bg-scale /home/andrew/Pictures/city.png
/home/andrew/scripts/redshift &

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

#Network Reconnection (requires root)
gksudo /home/andrew/scripts/net.sh &

#Conky status bar
conky | while read -r; do xsetroot -name "$REPLY"; done &

#Starts last so script exits on dwm exit
dwm
