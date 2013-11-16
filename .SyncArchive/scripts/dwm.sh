#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup file

#This includes all the things that are automatically started, as well as a few configuration options

#All program lines should end in an & except the last one. Any lines without a & cause issues (until the offending program is killed/exits, nothing else runs).

xrdb -merge ~/.Xresources &

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
		case "$x" in
		*OnlyShowIn*)
			#There ain't no-one in the 'verse putting "OnlyShowIn=dwm" in a .desktop file.
			#Similarly, ain't no-one putting "NotShowIn=dwm" in a .desktop file. Hence, both cases are ignored.
			;;
		*)
			#Theoretically, trusting the output to not do bad things is risky. Realistically, trusting it makes everything work nice.
				sh -c "$(echo "$x" | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
	done
	unset y
	unset x
fi

#Separated to prevent failure if one of the two directories doesn't exist.
if [[ -d $HOME/.config/autostart ]]; then
	for n in $HOME/.config/autostart/*; do
		m=$(cat $n)
		case $m in
		*OnlyShowIn*)
			;;
		*)
				sh -c "$(echo "$m" | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
	done
	unset n
	unset m
fi

#Autostart section to allow multiple .desktop files to use same script
#Potentially, could be expanded into a case check to allow more granularity than "clean" and "everything else".
if [[ "$1" != "clean" ]]; then
	pidgin &
	claws-mail &
#	dropboxd &
#	SpiderOak &
	transmission-gtk -m &
fi

#Power Management Script
$HOME/Scripts/bat.sh &

#Configuration Section
setxkbmap -layout gb -option terminate:ctrl_alt_bksp
# http://i.imgur.com/U9QgGDY.jpg
feh --bg-scale $HOME/Pictures/city.jpg
$HOME/Scripts/redshift &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

#Conky status bar
#conky | while read -r; do xsetroot -name "$REPLY"; done &

#dzen2 status bar
fgcolour="#0AA6CF"
bgcolour="#272822"
font="Fira Mono:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"
xsetroot -name " "
conky -c .conkyrcdzen | dzen2 -x "604" -h "13" -w "650" -ta r -fg "${fgcolour}" -bg "${bgcolour}" -fn "${font}" -e "${dzevents}" &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 10s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
