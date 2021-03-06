#!/bin/sh
#        _)     _)        _|
#    _` | |  __| | __ \  |    _ \
#   (   | | |    | |   | __| (   |
#  \__,_|_|_|   _|_|  _|_|  \___/
# Air Quality Index query script.
# Inspired by: https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/info-airqualityindex
# API Docs: https://aqicn.org/json-api/doc/
#
# This script is a wrapper around ..apitools/airinfo.sh that sends a request to the Air Quality Open Data Platform to get the air index quality at the specified locale, and prints a color value to color the output in polybar.
# A valid api key is required to be in a text file at $KEY_FILE (set to ~/.config/api-keys/airqualityindex-0.txt by default) in order for ../apitools/airinfo to work.
#
# The location can be set via the commandline argument (see geoloc), otherwise the default option will be used.
# Dependencies: geoloc, curl, jq, tr, sed

pb_aqi_color() {
	case "$1" in
		''|*[!0-9]*) printf "INVALID NUM" && exit 1;;
		[0-2][0-9]) printf "%%{F#00CD00}";;
		[3-4][0-9]) printf "%%{F#009966}";;
		[5-9][0-9]) printf "%%{F#FFDE33}";;
		[1][0-4][0-9]) printf "%%{F#FF9933}";;
		[1][5-9][0-9]) printf "%%{F#CC0033}";;
		[2][0-9][0-9]) printf "%%{F#660099}";;
		[3-9][0-9][0-9]) printf "%%{F#7E0023}";;
		*) printf '' ;;
	esac;
	exit 0;
}

#ping -q -c 1 9.9.9.9 > /dev/null || (printf '' && exit 1);
aqi=$(airinfo "$1");
exit_code=$?;

if [ "$exit_code" -ne 0 ]; then
	printf "AQI ERROR" && exit "$exit_code";
else
	printf "%s" "$(pb_aqi_color "$aqi")$aqi" && exit 0;
fi;
