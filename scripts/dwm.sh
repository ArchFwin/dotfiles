#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup file.
#This includes all the things that are automatically started, as well as a few configuration options

#Two if clauses to make dwm more compliant with how some people believe desktop environments should behave.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi &
#This parses the .desktop files in one of two autostart directories and executes them.
#/etc/xdg/autostart isn't included because it makes a complicated loop that has to check whether something should be started (i.e, finds "OnlyShowIn=KDE" or other similar things, and then ignores/runs them as appropriate).
if [ -d /home/andrew/.config/autostart ]; then
	for y in /home/andrew/.config/autostart/*; do
    	sh -c "$(cat $y | grep -m 1 "Exec" | sed 's/^Exec=//' | sed 's/ %.//')" &
	done
	unset y
fi &

#Autostart Section
btpd -p 6161 --max-peers 120 &
pidgin &
claws-mail &
/usr/lib/lxpolkit/lxpolkit &
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

#Power Management Script
/home/andrew/scripts/bat.sh &

#Configuration Section
setxkbmap gb
feh --bg-scale /home/andrew/Pictures/city.png

#Conky status bar
#conky | while read -r; do xsetroot -name "$REPLY"; done &

#dzen2 status bar
fgcolour="#0AA6CF"
bgcolour="#1a1a1a"
font="xft:Fira Mono:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"
xsetroot -name " " &
conky -c "$HOME/.conkyrcdzen" | dzen2 -x "740" -h "13" -w "800" -ta r -fg ${fgcolour} -bg ${bgcolour} -fn ${font} -e ${dzevents} &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 5s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
