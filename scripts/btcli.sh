#!/bin/sh
speed=$(btcli stat | tail -n 1 | grep -Eom 2 "[0-9]+.[0-9]+kB/s")
x=$(echo $speed | cut -d " " -f 1)
y=$(echo $speed | cut -d " " -f 2)
echo ↓${x} ↑${y}
