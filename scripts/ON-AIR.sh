#!/bin/bash

# Makes URY switch to term time mode - see README.md

echo "Warning! This will turn all broadcasts to jukebox"
echo " "
echo "Confirm"
read dummy

echo "Switching Program Out to Jukebox..."
sel 3

echo "Swithcing FM to Program Out (will require sudo password)..."
sudo -u liquidsoap /usr/local/etc/liquidsoap/scripts/fm_main.sh

echo "Unlocking Selectors..."
sel unlock

echo " "
sel query
echo " "

# Jamie P-E, HoC 2023
