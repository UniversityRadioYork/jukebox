#!/usr/local/bin/liquidsoap -v

%include "conf/ice.conf"
%include "conf/ob.conf"

set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/ob.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

def onOBConnect (stream) =
    system("#{obconnectscript} #{stream} #{status_file} #{email_state}")
end
def onOBDisconnect (stream) =
    system("#{obdisconnectscript} #{stream} #{status_file} #{email_state}")
end

# Get OB Stream

s1 = input.http("http://#{icehost}:#{iceport}/#{obmount}", on_connect = onOBConnect("s1"), on_disconnect = onOBDisconnect("s1"))
#ob = single("say: This is OB.")

output.jack(id="ob", mksafe(s1))
