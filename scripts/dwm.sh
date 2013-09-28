#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup file.
#This includes all the things that are automatically started, as well as a few configuration options

#Autostart Section
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi &
btpd -p 6161 --max-peers 120 &
pidgin &
claws-mail &
dropboxd &
SpiderOak &
/usr/lib/lxpolkit/lxpolkit &

#Power Management Script
/home/andrew/scripts/bat.sh &

#Configuration Section
setxkbmap gb
feh --bg-scale /home/andrew/Pictures/city.png
/home/andrew/scripts/redshift &

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

#Conky status bar
#conky | while read -r; do xsetroot -name "$REPLY"; done &

#dzen2 status bar
fgcolour="#0AA6CF"
bgcolour="#1a1a1a"
font="xft:Fira Mono:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"
xsetroot -name " "
conky -c .conkyrcdzen | dzen2 -x "740" -h "13" -w "600" -ta r -fg ${fgcolour} -bg ${bgcolour} -fn ${font} -e ${dzevents} &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 5s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
