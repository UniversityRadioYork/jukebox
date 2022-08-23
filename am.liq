#!/usr/local/bin/liquidsoap -v

# Bolted on by Matthew Stratford 2018 <matthew@mstratford.net>

%include "conf/ice.conf"
%include "conf/jukebox.conf"
#%include "conf/am.conf"

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/am.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/am.log")

#def on_catastrophic_blank()
#  system(catastrophic_blankscript)
#end

# Sources
am = input.jack(id="am")

am = amplify(1.0, am)

# Dead Air detection
# am = on_blank(max_blank=45.0, threshold=-55.0, track_sensitive=false, on_catastrophic_blank, am)

clock.assign_new(id="amStream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="am",
    url=website,
    description=description,
    name="AM Reciever Feed",
    genre="Student Radio",
    mksafe(buffer(am)))])
