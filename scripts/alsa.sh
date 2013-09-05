#!/bin/sh
vol=$(amixer get Master | tail -n 1 | sed 's/Front//g')
case $vol in
*on*)
	vol=$(echo $vol | grep -oE "[[:digit:]]*%")
	;;
*off*)
	vol=$(echo $vol | grep -oE "[[:digit:]]*%" | sed 's/$/ \[M\]/g')
	;;
esac
echo $vol 
