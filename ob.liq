#!/usr/local/bin/liquidsoap -v

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/ob.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/ob.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

set("server.telnet",true)
set("server.telnet.bind_addr", "127.0.0.1")
set("server.telnet.port", 1399)

# Get OB Stream

ob = audio_to_stereo(input.http("http://dolby.ury.york.ac.uk:7070/OB-Line"))

# Benjamin Ballenson's fuckery
ob_new = audio_to_stereo(input.http("http://urysteve.ury.york.ac.uk/OB-Line"))

ob = mksafe(fallback([ob, ob_new]))

output.jack(id="ob", mksafe(ob))
