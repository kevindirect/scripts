#!/bin/sh
#                     _
#    _________  _____(_)_______
#   / ___/ __ \/ ___/ / ___/ _ \
#  / /__/ /_/ / /  / / /__/  __/
#  \___/ .___/_/  /_/\___/\___/
#     /_/
# Coin price query script.
#
# Commandline Args:
# 	* -f (significant figures), The number of sigfigs to output, uses 2 by default.
# 	* -s (symbol), valid Coinmarketcap symbol (ie 'ETH')
# Dependencies: coinquote, bc, sed, curl, jq
# Outputs Format: $<price> <1 hr pct>% <24hr pct>% <7d pct>%
# Just a wrapper around coinquote.sh for polybar (queries Coinmarketcap API).

coin_price() {
	SIGFIG="$1";
	SYMBOL="$2";
	SCALAR=$(echo "10 ^ $SIGFIG" | bc);

	coinquote "$SYMBOL" | jq ".price, .percent_change_1h, .percent_change_24h, .percent_change_7d | . * $SCALAR | round | . / $SCALAR" | sed '1s/^/$/; 2,4s/$/%/' | tr '\n' ' ';
}

# Defaults:
SIGFIG=2;
SYMBOL='ETH';

while getopts 'f:s:' arg; do
	case $arg in
		f) SIGFIG="$OPTARG";;
		s) SYMBOL="$OPTARG";;
		*) notify-send "cprice" "invalid flag";;
	esac;
done;

coin_price "$SIGFIG" "$SYMBOL";

