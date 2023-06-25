#!/bin/bash

# Makes URY switch to academic holiday mode - see README.md

echo "WARNING!!! THIS WILL TURN ON OFF-AIR MODE"
echo " "
echo "Confirm"
read dummy

echo "Locking Selectors..."
sel lock

echo "Swithcing FM to Jukebox (will require sudo password)..."
sudo -u liquidsoap /usr/local/etc/liquidsoap/scripts/fm_jukebox.sh

echo "Selecting Off Air Loop for Online & AM..."
sel 8

echo " "
sel query
echo " "

# Jamie P-E, HoC 2023
