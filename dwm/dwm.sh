#!/bin/sh
# Maintainer = Andrew Webley <UnsuspectingHero@gmail.com>
# DWM startup file.
# Includes basic power management, adds volume, battery and time indications to status bar and autostarts all useful things. This will run throughout the whole xsession.

# Obviously, dwm must be started. Starts first to ensure usable desktop if something later is broken, and exits the script if it doesn't run properly.
dwm &

# Autostart Section
transmission-gtk -m &
pidgin &
claws-mail &
dropboxd &
SpiderOak &
pulseaudio --start &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
export {SSH_AUTH_SOCK,GPG_AGENT_INFO,GNOME_KEYRING_CONTROL,GNOME_KEYRING_PID} &
/home/andrew/redshift &

# Configuration Section
setxkbmap gb
feh --bg-scale /home/andrew/Pictures/GITS_Laughing_Man_wall_02_by_pansejra.jpg

#Automatic screen-lock and suspend
xautolock -time 5 -locker "slock" -killer "systemctl suspend" -killtime 10 -detectsleep &

# Initialise warnings early to prevent problems with the if clause.
war=0
war2=0
war3=0

# Status bar infinite loop. Because never-ending programs are cool, right?
while true; do
	# Due to the nature of acpi data...the battery information is innacurate for a few seconds after the battery status changes.
	batt=$(acpi -b)
	case $batt in
	*Discharging*)
    	batt=$(echo $batt | cut -d " " -f 4-5 | sed 's/,//g' | sed 's/$/ [D]/g')
	    # Simple, naive Power Management in the discharging case. Avoids needless calculations and (partially) avoids suspend loops
    	batt1=$(echo $batt | cut -d "%" -f 1)
        if [[ $batt1 < "20" && $war != "1" ]]; then
            notify-send -a "Power Management" "Battery getting kinda low" ""
            war="1"
    	elif [[ $batt1 < "10" && $war2 != "1" ]]; then
	        notify-send -a "Power Management" "Battery really low"
        	war2="1"
    	    war="1"
        elif [[ $batt1 < "1" && $war3 != "1" ]]; then
            notify-send -u critical -a "Power Management" "Battery Critical" 
			# Warning variables used to prevent suspend loops occuring. Also, new battery notifications every 0.5s.
            war="1"
            war2="1"
            war3="1"
			# Gives time to read notification before suspension.
            sleep 2s
            systemctl suspend
	    fi
	    ;;  
	*Charging*)
	    batt=$(echo $batt | cut -d " " -f 4-5 | sed 's/,//g' | sed 's/$/ [C]/g')
		# Reset warning variables, so we can suspend again after recharging battery.
		war3="0"
		war2="0"
		war1="0"
	    ;;  
	*Full*)
	    batt=$(echo $batt | cut -d " " -f 4 )
		;;
	*)
		# The battery is probably missing if this shows up. Otherwise, fuck.
		batt="Gone Fishing"
    	;;  
	esac
	# Mono and Front have to be removed first otherwise *on* will match both of them, which isn't desirable.We also only want one result, so grep is set to match one outpt twice.
	vol=$(amixer get Master | grep -m 1 "%" | sed 's/Mono//g' | sed 's/Front//g')
	case $vol in
	*on*)
    	vol=$(echo $vol | grep -P -m 1 -o ".{0,3}\%" | sed 's/\[//g')
	    ;;  
	*off*)
    	vol=$(echo $vol | grep -P -m 1 -o ".{0,3}\%" | sed 's/\[//g' | sed 's/$/ [M]/g')
	    ;;  
	*)
		#If the volume is neither off nor on, then either something before this is wrong, or your system is fucked. Try manually running "amixer get Master" in a terminal to see if it's a script problem or an alsa problem.
	    vol="Fuck."
	esac
	#Date in the one true format, with the accuracy removed.
	date=$(date --rfc-3339=seconds | sed 's/+01:00//g')
	#Without this, this is basically just a big while loop to waste battery power.
	xsetroot -name "Vol:$vol Bat:$batt $date"
	#Prevent the loop looping too much, while updating often enough that the seconds are accurate.
	sleep 0.5s

done &
sleep 0.5m
#I like nm-applet to be as close to the time as possible. This helps ensure that happens.
nm-applet
#wicd-gtk -t

#Dependencies
#acpi sed echo grep cut notify-send xautolock slock systemd amixer date xsetroot sleep setxkbmap feh
#All the various autostart programs also.
#This is the end.
