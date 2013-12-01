#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup script

#All program lines should end in an & except the last one. Any lines without a & cause issues (until the offending program is killed/exits, nothing else runs).

#Include various options set in the ~/.Xresources file
xrdb -merge "$HOME"/.Xresources &

# Start system autostart files/scripts if they exist

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [[ -x "$f" ]] && . "$f" &
  done
  unset f
fi

if [[ -d /etc/xdg/autostart ]]; then
	for y in /etc/xdg/autostart/*; do
		x=$(cat $y)
		case "$x" in
		*OnlyShowIn*)
			#There ain't no-one in the 'verse putting "OnlyShowIn=dwm" in a .desktop file.
			#Similarly, ain't no-one putting "NotShowIn=dwm" in a .desktop file. Hence, both cases are ignored.
			;;
		*)
			#Desktop file parsing.
			sh -c "$(echo "$x" | grep -m 1 "Exec=" | sed 's/Exec=//g')" &
			;;
		esac
	done
	unset y
	unset x
fi

#Default empty autostart for clean
autostart=('')

#Add items to autostart for full only
[[ "$1" = "full" ]] && autostart +=('firefox-ux' 'spotify' 'sakura')

#partial/full autostart loop
if [[ "$1" = "partial" || "$1" = "full" ]]; then
	#Autostart items in full and partial
	autostart+=('pidgin' 'claws-mail' 'transmission-gtk -m')
	#Secondary autostart directory, nothing important started here so okay to skip in clean for minimal session
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
	#Runs everything in the autostart array
	for x in "${autostart[@]}"; do
		$x &
	done

#Power Management Script
$HOME/Scripts/bat.sh &

#Configuration Section
setxkbmap -layout gb -option terminate:ctrl_alt_bksp -option compose:menu
# http://i.imgur.com/U9QgGDY.jpg
feh --bg-scale $HOME/Pictures/city.jpg
$HOME/Scripts/redshift &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

#Dzen is set to be slightly further left than the end of the systray. This simply hides ``dwm-6.0'' from view.
xsetroot -name " "

#dzen2 status bar
fgcolour="#0AA6CF"
bgcolour="#272822"
font="Fira Mono:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"

conky -c .conkyrc | dzen2 -x "604" -h "13" -w "650" -ta r -fg "${fgcolour}" -bg "${bgcolour}" -fn "${font}" -e "${dzevents}" &

#Dzen starts before dwm, so this is used to make dzen go over the dwm bar
sleep 10s && kill -USR1 `pgrep dzen` &

#Starts last so script exits on dwm exit
dwm
