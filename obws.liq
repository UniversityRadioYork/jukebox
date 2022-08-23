#!/usr/local/bin/liquidsoap -v

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/obws.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/obws.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

ob = input.jack(id="obws_ob")
webstudio = input.jack(id="obws_ws")

result = add(normalize=false, [ob, webstudio])

output.jack(id="obws_out", mksafe(result)) 
