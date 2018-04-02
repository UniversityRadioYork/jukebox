#!/usr/local/bin/liquidsoap -v

# Based on jukebox.liq
# Off Air Loop script by Matthew Stratford <matthew.stratford@ury.org.uk>
# Launched on URY Tue 27-03-2018

%include "conf/ice.conf"
%include "conf/jukebox.conf"

set("log.stdout",true)
set("log.level",3)
#set("server.telnet.bind_addr", telnetaddr)
#set("server.telnet", true)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/off-air.log")

# That loop that is ever so catchy, right?!
offlineLoop = mksafe(single("/jukebox/offlineLoop.wav"))

# Jingles every 5min~ish
jingles = playlist(reload_mode="watch", "/jukebox/jingles")
jingles = delay(300. , jingles)

offlineLoop = amplify(2.,offlineLoop)

# Put all the pieces together
offair = fallback([jingles, offlineLoop])

# Avoid too much blank/silence between jingles and offline loop.
offair = skip_blank(max_blank=0.1, offair)

# Apply replay gain
#offair = amplify(1.,override="replay_gain", offair)

offair = amplify(0.2, offair)

# Output to soundcards
output.jack(id="offair", start=true, offair)
