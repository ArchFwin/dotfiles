#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup file.
#This includes all the things that are automatically started, as well as a few configuration options
#That should extend to all of the various autostart directories.
xrdb -merge ~/.Xresources
#Autostart Section
if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [[ -x "$f" ]] && . "$f"
  done
  unset f
fi &

#Xdg Autostart Compliance
if [[ -d /etc/xdg/autostart ]]; then
	for y in /etc/xdg/autostart/*; do
		x=$(cat $y)
		case $x in
		#It's unlikely that a .desktop file will mention dwm, so the possibility is ignored.
		*OnlyShowIn*)
			;;
		*)
			sh -c "$(echo $x | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
		unset x
	done
	unset y
fi &
#Separated to prevent failure if one of the two directories doesn't exist
if [[ -d $HOME/.config/autostart ]]; then
	for n in $HOME/.config/autostart/*; do
		m=$(cat $n)
		case $m in
		*OnlyShowIn*)
			;;
		*)
			sh -c "$(echo $m | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
		unset m
	done
	unset n
fi &

btpd -p 6161 --max-peers 120 --bw-out 300 --bw-in 1000 --ip 8.8.8.8 --max-uploads -1 &
pidgin &
claws-mail &
dropboxd &
SpiderOak &

#Power Management Script
/home/andrew/scripts/bat.sh &

#Configuration Section
setxkbmap gb
# http://i.imgur.com/U9QgGDY.jpg
feh --bg-scale /home/andrew/Pictures/city.jpg
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
conky -c .conkyrcdzen | dzen2 -x "674" -h "13" -w "600" -ta r -fg ${fgcolour} -bg ${bgcolour} -fn ${font} -e ${dzevents} &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
#sleep 10s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
