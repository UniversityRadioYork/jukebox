#!/usr/local/bin/liquidsoap -v

#%include "conf/sel.conf"
%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/stereotool.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/stereotool.log')

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
studio1 = input.jack(id="stool_out")

output.icecast(
        %mp3(bitrate=192),
        host=icehost,
        port=iceport,
        password=icepass,
        mount="stereotool",
        url=website,
        description="TEST STEREOTOOL " ^ description,
        name="URY SelOut | " ^ name,
        genre="Student Radio",
	start=true,
        mksafe(buffer(studio1))
    )
