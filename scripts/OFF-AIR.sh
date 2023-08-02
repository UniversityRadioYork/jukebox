echo "WARNING!!! THIS WILL TURN ON OFF-AIR MODE"
echo " "
echo "Confirm"
read dummy

echo "Selecting Off Air Loop..."
sel 8

echo "Locking Selectors..."
sel lock

#echo "Swithcing FM to Jukebox (will require sudo password)..."
#sudo -u liquidsoap /usr/local/etc/liquidsoap/scripts/fm_jukebox.sh
# ^ Deperecated after a change in how we sent audio to the FM Pi

echo "switching FM to jukebox"
curl -X POST -d source=1 localhost:5001/source # Contact Michael Grace if this breaks lol

echo " "
sel query
echo " "
