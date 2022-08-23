#!/usr/local/bin/liquidsoap -v

# Bolted on by Matthew Stratford 2018 <matthew@mstratford.net>

%include "conf/ice.conf"
#%include "conf/jukebox.conf"
#%include "conf/am.conf"

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/recievers.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/receivers.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
am = input.jack(id="am")
am = amplify(1.0, am)
fm = input.jack(id="fm")
fm = amplify (2.5, fm)

clock.assign_new(id="amStream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="am",
    url=website,
    description=description,
    name="AM Reciever Feed | " ^ name,
    genre="Student Radio",
    start=true,
    mksafe(buffer(am)))],
)

clock.assign_new(id="fmStream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="fm",
    url=website,
    description=description,
    name="FM Reciever Feed | " ^ name,
    genre="Student Radio",
    start=true,
    mksafe(buffer(fm)))],
)
