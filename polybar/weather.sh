#!/bin/sh
location="$1"; [ -z "$location" ] || { location="$location+" && rm -f "$HOME/.local/share/weatherreport" ;}

getforecast() { ping -q -c 1 1.1.1.1 >/dev/null || exit 1
curl -s "wttr.in/$location" > "$HOME/.local/share/weatherreport" || exit 1 ;}

showweather() { printf "%s" "$(sed '16q;d' "$HOME/.local/share/weatherreport" | grep -wo "[0-9]*%" | sort -n | sed -e '$!d' | sed -e "s/^/ﭽ /g" | tr -d '\n')"
sed '13q;d' "$HOME/.local/share/weatherreport" | grep -o "m\\(-\\)*[0-9]\\+" | sort -n -t 'm' -k 2n | sed -e 1b -e '$!d' | tr '\n|m' ' ' | awk '{print " ﰕ",$1 "°","",$2 "°"}' ;}

if [ "$(stat -c %y "$HOME/.local/share/weatherreport" >/dev/null 2>&1 | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ]
	then getforecast && showweather
	else showweather
fi
