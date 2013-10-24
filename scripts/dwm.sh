#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup file.
#This includes all the things that are automatically started, as well as a few configuration options
<<<<<<< HEAD

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
=======
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

pidgin &
claws-mail &
dropboxd &
SpiderOak &
transmission-gtk -m &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361

#Power Management Script
/home/andrew/scripts/bat.sh &

#Configuration Section
setxkbmap gb
<<<<<<< HEAD
feh --bg-scale /home/andrew/Pictures/city.png
=======
# http://i.imgur.com/U9QgGDY.jpg
feh --bg-scale /home/andrew/Pictures/city.jpg
/home/andrew/Scripts/redshift &

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361

#Conky status bar
#conky | while read -r; do xsetroot -name "$REPLY"; done &

#dzen2 status bar
fgcolour="#0AA6CF"
bgcolour="#1a1a1a"
font="xft:Fira Mono:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"
<<<<<<< HEAD
xsetroot -name " " &
conky -c "$HOME/.conkyrcdzen" | dzen2 -x "740" -h "13" -w "800" -ta r -fg ${fgcolour} -bg ${bgcolour} -fn ${font} -e ${dzevents} &
=======
xsetroot -name " "
conky -c .conkyrcdzen | dzen2 -x "524" -h "13" -w "750" -ta r -fg "${fgcolour}" -bg "${bgcolour}" -fn "${font}" -e "${dzevents}" &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 10s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
