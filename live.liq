#!/usr/local/bin/liquidsoap -v

%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/live.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/live.log')

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Sources
live = input.jack(id="liveOutput")

live = amplify({ 2.0 }, live)

# High Quality Live Stream
output.icecast(
    %mp3(bitrate=192),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="live-high",
    start=true,
    url=website,
    description=description,
    name="#{name} - High Quality",
    genre="Student Radio",
    live)

# High Quality Live Stream (ogg)
output.icecast(
    %vorbis.cbr(bitrate=128),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="live-high-ogg",
    icy_metadata="true",
    start=true,
    url=website,
    description=description,
    name="#{name} - OGG Stream",
    genre="Student Radio",
    live)

# Mobile Live Stream
output.icecast(
    %mp3(bitrate=48, samplerate=44100, stereo=false),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="live-mobile",
    start=true,
    url=website,
    description=description,
    name="#{name} - Mobile",
    genre="Student Radio",
    mean(live)) #Mean the two channels together to make mono

# Registration on flows
# Tell the world how awesome we are
ignore(
    register_flow(
        radio=name,
        website=website,
        description=description,
        genre="Student Radio",
        streams=[
            ("mp3/192k", "http://#{icehost}:#{iceport}/live-high"),
            ("ogg/192k", "http://#{icehost}:#{iceport}/live-high-ogg")
        ],
        live
    )
)
