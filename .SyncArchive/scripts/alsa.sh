#!/bin/zsh
vol=$(amixer get Master | tail -n 1 | sed 's/Front//g' | sed 's/Mono//g')
case $vol in
*on*)
	vol=$(echo $vol | grep -oEm 1 "[[:digit:]]+%")
	;;
*off*)
	vol=$(echo $vol | grep -oEm 1 "[[:digit:]]+%" | sed 's/$/ \[M\]/g')
	;;
esac
echo $vol 
