#!/usr/bin/env bash
echo "WARNING!!! THIS WILL TURN ON OFF-AIR MODE"

echo " "
echo "Confirm"
read dummy

echo "Selecting Off Air Loop..."
sel 8

echo "Locking Selectors..."
sel lock

echo "switching FM to jukebox"
curl -X POST -d source=1 localhost:5001/source # Equivalent of `fm jb` command

echo " "
sel query
echo " "
