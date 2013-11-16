#!/bin/sh
while true; do
	batt=$(acpi -b | cut -d " " -f 3)
	case $batt in
	Full,*)
		let war=0
		let war2=0
		;;
	Charging,*)
		let war=0
		let war2=0
		;;
	Discharging,*)
		bat=$(acpi -b | grep -oE "[[:digit:]]*%" | sed 's/%//g')
		if [[ "$bat" < "10" && $war != "1" ]]; then
			notify-send -a "Power Management" "Battery low" "Go fuck a duck."
			let war=1
		elif [[ "$bat" < "5" && $war2 != "1" ]]; then
			notify-send -a "Power Management" "Battery critical" "We're going down now."
			let war2=1
			sleep 10s
			systemctl suspend
		fi
		;;
	esac
	sleep 30s
done
