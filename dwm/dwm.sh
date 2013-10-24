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
<<<<<<< HEAD
#It's unlikely that a .desktop file will mention dwm, so the possibility is ignored.
=======
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361
if [[ -d /etc/xdg/autostart ]]; then
	for y in /etc/xdg/autostart/*; do
		x=$(cat $y)
		case $x in
<<<<<<< HEAD
=======
		#It's unlikely that a .desktop file will mention dwm, so the possibility is ignored.
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361
		*OnlyShowIn*)
			;;
		*)
			sh -c "$(echo $x | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
		unset x
	done
	unset y
<<<<<<< HEAD
fi
=======
fi &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361
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
<<<<<<< HEAD
fi

#Autostart section to allow multiple .desktop files to use same script
if [[ "$1" != "clean" ]]; then
	pidgin &
	claws-mail &
	dropboxd &
	SpiderOak &
	transmission-gtk -m &
fi
=======
fi &

pidgin &
claws-mail &
dropboxd &
SpiderOak &
transmission-gtk -m &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361

#Power Management Script
$HOME/scripts/bat.sh &

#Configuration Section
setxkbmap gb
# http://i.imgur.com/U9QgGDY.jpg
feh --bg-scale /home/andrew/Pictures/city.jpg
<<<<<<< HEAD
$HOME/Scripts/redshift &

#Things that need to run in all sessions
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

#Only start nm-applet if network-manager is running
[[ `pgrep NetworkManager` ]] && nm-applet &
=======
/home/andrew/Scripts/redshift &
>>>>>>> 54557b780ce9ca0e73a607b0b54bbfd8b1048361

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
conky -c .conkyrcdzen | dzen2 -x "524" -h "13" -w "750" -ta r -fg "${fgcolour}" -bg "${bgcolour}" -fn "${font}" -e "${dzevents}" &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 10s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
