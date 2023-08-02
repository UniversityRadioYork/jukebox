#!/bin/bash

# Makes URY switch to academic holiday mode - see README.md

# THIS SCRIPT HAS BEEN FORKED FROM OFF-AIR.sh FOR USE WITH A CRON SCRIPT

echo "Swithcing FM to Jukebox (will require sudo password)..."
sudo -u liquidsoap /usr/local/etc/liquidsoap/scripts/fm_jukebox.sh

echo "Selecting Off Air Loop for Online & AM..."
sel 8

echo " "
sel query
echo " "

# Jamie P-E, HoC 2023
