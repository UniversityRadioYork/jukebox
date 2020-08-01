#!/usr/local/bin/liquidsoap -v

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/ob.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/ob.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Get OB Stream

ob = audio_to_stereo(input.http("http://icecast.ury.york.ac.uk:7070/OB-Line"))

# Backup fallback
ob_new = audio_to_stereo(input.http("http://urysteve.ury.york.ac.uk/OB-Line"))

ob = mksafe(fallback([ob, ob_new]))

output.jack(id="ob", mksafe(ob))