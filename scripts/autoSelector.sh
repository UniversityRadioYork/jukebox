#!/bin/bash
#AutoSelector runs thonkyBoi
# Called AutoSelector to maybe remove confusion with old autoSwitcher, which is now webStudioSwitcher.sh
# This line ^^ is now out of date XD
# Ask me if you have questions :) - Michael

#go run autoswitch_thonkyBoi.go &
cd thonkyBoi
./thonkyBoi &
cd ..
sleep 30

python3 -u /usr/local/etc/liquidsoap/scripts/webStudioSwitcher.py &
python3 -u /usr/local/etc/liquidsoap/scripts/autoNews.py &

wait
