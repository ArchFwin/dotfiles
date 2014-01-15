#!/bin/sh
#Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
#DWM startup script

# Base autostart array - everything in it starts all the time
# Only used for stuff that runs in the background, configuration options and background setting
# http://www.wallsave.com/wallpapers/1920x1080/cyber-punk/1149403/cyber-punk-tattoos-women-cyberpunk-barcode-artwork-1149403.jpg
autostart=( '$HOME/Scripts/bat.sh'
			'setxkbmap -layout gb -option terminate:ctrl_alt_bksp -option compose:menu'
			'feh --bg-scale $HOME/Pictures/cyber.jpg'
			'redshift -l 55.8:-4.35 -t 5700:3600 -g 0.8 -m vidmode -v'
			'gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh'
			'xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep'
			'xrdb -merge "$HOME"/.Xresources'
			'xsetroot -name " "')

# Add items to autostart for full only
[[ "$1" = "full" ]] && autostart+=(	'firefox-ux'
									'spotify'
									'sakura')

# Partial/full autostart additions
if [[ "$1" = "partial" || "$1" = "full" ]]; then
	# Autostart items in full and partial
	autostart+=('thunderbird')
	# Secondary autostart directory, nothing important started here so okay to skip in clean for minimal session
	if [[ -d $HOME/.config/autostart ]]; then
		for n in $HOME/.config/autostart/*; do
			m=$(cat $n)
			case $m in
			*OnlyShowIn*)
				;;
			*)
				autostart+=("$(echo "$m" | grep -m 1 "Exec=" | sed 's/Exec=//g')")
				;;
			esac
		done
		unset n
		unset m
	fi
fi

# System autostart directories
if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    autostart+=("$f")
  done
  unset f
fi

if [[ -d /etc/xdg/autostart ]]; then
	for y in /etc/xdg/autostart/*; do
		x=$(cat $y)
		case "$x" in
		*OnlyShowIn*)
			# There ain't no-one in the 'verse putting "OnlyShowIn=dwm" in a .desktop file
			# Similarly, ain't no-one putting "NotShowIn=dwm" in a .desktop file. Hence, both cases are ignored
			;;
		*)
			autostart+=("$(echo "$x" | grep -m 1 "Exec=" | sed 's/Exec=//g')")
			;;
		esac
	done
	unset y
	unset x
fi

export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK &

# Runs everything in the autostart array simultaneously without blocking startup
for x in "${autostart[@]}"; do
	eval "$x" &
	# Give it a little time to start
	sleep 0.1s
done

#dzen2 status bar - sleeps on startup so it isn't below the dwm bar.
fgcolour="#0AA6CF"
bgcolour="#272822"
font="Fira Mono OT:size=8"
dzevents="key_Escape=exit;sigusr1=raise;sigusr2=lower;"

sleep 10s && conky -c .conkyrc | dzen2 -x "-620" -h "13" -w "500" -ta r -fg "${fgcolour}" -bg "${bgcolour}" -fn "${font}" -e "${dzevents}" &

# Starts last so script exits on dwm exit
# Not backgrounded to prevent script exiting and lxdm killing everything
dwm
