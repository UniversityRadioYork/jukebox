#!/usr/local/bin/liquidsoap -v

# Bolted on by Matthew Stratford 2018 <matthew@mstratford.net>

%include "conf/ice.conf"
%include "conf/jukebox.conf"

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/news.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/news.log")

# Sources
news = input.jack(id="news")

#news = amplify(2., news)

clock.assign_new(id="newsStream",
[output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="news",
    url=website,
    description=description,
    name="IRN/Sky News Feed",
    genre="Student Radio",
    mksafe(buffer(news)))])
