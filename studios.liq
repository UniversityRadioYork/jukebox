#!/usr/local/bin/liquidsoap -v

%include "conf/sel.conf"
%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/studios.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/studios.log')


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
        description="Direct feed from Studio Red",
        name="URY Studio Red",
        genre="Student Radio",
        studio1
    )

output.icecast(
        %mp3(bitrate=192),
        host=icehost,
        port=iceport,
        password=icepass,
        mount="studio-blue",
        url=website,
        description="Direct feed from Studio Blue",
        name="URY Studio Blue",
        genre="Student Radio",
        studio2
    )
