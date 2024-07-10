#!/usr/bin/env bash
echo "Warning! This will turn all broadcasts to jukebox"
echo " "
echo "Confirm"
read dummy

echo "Switching Program Out to Jukebox..."
sel 3

echo "swtiching FM to PGM out"
curl -X POST -d source=0 localhost:5001/source  # Equivalent of `fm pgm` command

echo "Unlocking Selectors..."
sel unlock

echo " "
sel query
echo " "
