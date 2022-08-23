#!/usr/local/bin/liquidsoap -v

#%include "conf/sel.conf"
%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/webstudio.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/webstudio.log')

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
ws = input.jack(id="wspreanews")

#AutoNews
autonews = input.jack(id="autonews")
ws = add([ws, mksafe(autonews)])

output.jack(id="wspostanews", start=true, ws)

output.icecast(
        %mp3(bitrate=192),
        host=icehost,
        port=iceport,
        password=icepass,
        mount="webstudio",
        url=website,
        description="Direct feed from WebStudio. " ^ description,
        name="URY WebStudio | " ^ name,
        genre="Student Radio",
	start=true,
        mksafe(buffer(ws))
    )

