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

# Setup Campus Playout
campus_playout_studio = ref false

def onCampusPlayout () =
    !campus_playout_studio
end
def toggleCampusPlayout (_) =
    campus_playout_studio := not !campus_playout_studio
    "Studio Campus Playout is now #{!campus_playout_studio}"
end
server.register("toggleCampusPlayout", toggleCampusPlayout)

# Sources
live = input.jack(id="liveOutput")

jukebox = input.jack(id="liveJukebox")

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

# HLS stream
#hls_low = %fdkaac(
#	channels=2,
#	bandwidth="auto",
#	bitrate=48,
#	afterburner=true,
#	aot="mpeg4_he_aac_v2",
#	transmux="adif"
#)

#hls_med = %fdkaac(
#	channels=2,
#	bandwidth="auto",
#	bitrate=96,
#	afterburner=true,
#	aot="mpeg4_aac_lc",
#	transmux="adts"
#)

#hls_hi = %fdkaac(
#	channels=2,
#	bandwidth="auto",
#	bitrate=192,
#	afterburner=true,
#	aot="mpeg4_aac_lc",
#	transmux="adts"
#)

#streams = [
#	("aac_low", hls_low),
#	("aac_med", hls_med),
#	("aac_hi", hls_hi)
#]

#def segment_name(~position,~extname,stream_name) =
#  timestamp = int_of_float(gettimeofday())
#  duration = 2
#  "#{stream_name}_#{duration}_#{timestamp}_#{position}.#{extname}"
#end

#output.file.hls(
#	playlist="live.m3u8",
#	segment_duration=2.0,
#	segments=5,
#	segments_overhead=10,
#	segment_name=segment_name,
#	persist=true,
#	persist_at="/usr/local/share/liquidsoap/hls/state.config",
#	"/usr/share/icecast2/web/live-hls",
#	streams,
#	live
#)

# Campus Playout Stream
campus_playout = mksafe(
    switch(
        track_sensitive=false,
        [
            (onCampusPlayout, live),
            ({true}, jukebox)
        ]
    )
)

output.icecast(
    %mp3(bitrate=192),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="campus-playout-dev",
    icy_metadata="true",
    start=true,
    url=website,
    description=description,
    name="#{name} - Campus Playout",
    genre="Student Radio",
    campus_playout)

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
