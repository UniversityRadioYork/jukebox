#!/usr/bin/env bash
echo "Warning! This will turn all broadcasts to jukebox"
echo " "
echo "Confirm"
read dummy

echo "Switching Program Out to Jukebox..."
sel 3

#echo "Swithcing FM to Program Out (will require sudo password)..."
#sudo -u liquidsoap /usr/local/etc/liquidsoap/scripts/fm_main.sh
# ^ Deperecated after a change in how we sent audio to the FM Pi

echo "swtiching FM to PGM out"
curl -X POST -d source=0 localhost:5001/source  # Contact Michael Grace if this breaks lol

echo "Unlocking Selectors..."
sel unlock

echo " "
sel query
echo " "
