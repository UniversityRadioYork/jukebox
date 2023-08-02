#!/usr/local/bin/liquidsoap -v

#%include "conf/sel.conf"
%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/studios.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/studios.log')

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
studio1 = input.jack(id="directStudio1")
studio2 = input.jack(id="directStudio2")

output.icecast(
        %mp3(bitrate=192),
        host=icehost,
        port=iceport,
        password=icepass,
        mount="studio-red",
        url=website,
        description="Direct feed from Studio Red. " ^ description,
        name="URY Studio Red | " ^ name,
        genre="Student Radio",
	start=true,
        mksafe(buffer(studio1))
    )

output.icecast(
        %mp3(bitrate=192),
        host=icehost,
        port=iceport,
        password=icepass,
        mount="studio-blue",
        url=website,
        description="Direct feed from Studio Blue. " ^ description,
        name="URY Studio Blue | " ^ name ,
        genre="Student Radio",
	start=true,
        mksafe(buffer(studio2))
    )
