No idea what most of these scripts do but:

OFF-AIR.sh
## Makes URY switch to academic holiday mode:
# Locks the studio selectors so no one messes with the setup during the holidays
# Switches FM to exclusively jukebox (direct feed)
# Switches Online & AM to an OFF air loop

ON-AIR.sh
## Reverses the above, prepares URY for people to do shows for the term:
# Switches program out (Online & AM) to Jukebox
# Switches FM back to the program out feed
# Unlocks the studio selectors 

# Ran by other bash scripts:
	fm_main.sh
##	Switches FM to main program out feed
#        Ran by ON-AIR.sh
# 	 Needs to be run as liquidsoap user: "sudo -u liquidsoap fm_main.sh"

	fm_jukebox.sh
## 	Switches FM to a direct feed from jukebox 
#	 Ran by OFF-AIR.sh
# 	 Needs to be run as liquidsoap user: "sudo -u liquidsoap fm_jukebox.sh"


restartJukebox.sh
## Does what it says on the tin
# It restarts Jukebox - can fix issues

### Yours, Jamie P-E 
### Head of Computing 2023
### Feel free to contact me: jamie.parker-east@ury.org.uk
