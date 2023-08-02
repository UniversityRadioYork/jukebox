#!/usr/local/bin/liquidsoap -v

# Bolted on by Matthew Stratford 2018 <matthew@mstratford.net>

%include "conf/ice.conf"
#%include "conf/jukebox.conf"

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/news.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/news.log")

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
news = input.jack(id="news")
#techdiff = single("/jukebox/TechnicalDifficultiesVoice.mp3")
#news = playlist(reload_mode="watch", "/jukebox/jingles")

# Bodge for the StratSat
news = audio_to_stereo(stereo.left(news))

def on_silence() = 
	ignore(system("/usr/local/etc/liquidsoap/scripts/dishy_boi.sh"))
end
news = on_blank(max_blank=180.0, start_blank=false, on_silence, news)

news = amplify(1.5, news)

output.jack(id="fakeNews", start=true, news)

news2 = input.jack(id="news2")
news2 = amplify(1.5, news2)

clock.assign_new(id="newsStream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="news",
    url=website,
    description=description,
    name="IRN/Sky News Feed | " ^ name,
    genre="Student Radio",
    start=true,
    mksafe(buffer(news)))])

clock.assign_new(id="news2Stream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="news2",
    url=website,
    description=description,
    name="IRN 2 Feed | " ^ name,
    genre="Student Radio",
    start=true,
    mksafe(buffer(news2)))])
