#!/usr/local/bin/liquidsoap -v

# Coded by Gareth Lloyd <gareth@ignition-web.co.uk>
# & Lloyd Wallis <flump5281@gmail.com>
# & Andy Durant <andy@ajdurant.co.uk>
# Launched on URY 2012-01-27 00:36

%include "conf/ice.conf"
%include "conf/jukebox.conf"

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/jukebox.pid")
set("log.stdout",true)
set("log.level",5)
set("server.telnet.bind_addr", telnetaddr)
set("server.telnet", true)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/jukebox.log")
set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)
#set("audio.converter.samplerate.libsamplerate.quality","best")


# Local file if music filestore isn't
interludelong = mksafe(single("/jukebox/intermission-long.mp3"))
interludelong = crossfade(duration=2., fade_in=1.2, fade_out=1.2, interludelong)
techdiff = single("/jukebox/TechnicalDifficultiesVoice.mp3")
techlude = add([interludelong, switch([({0s}, techdiff)])])

# Playlists - used if MyRadio script breaks

# Normal (Backup) playlist
backup_playlist = playlist(reload_mode="watch", "/jukebox/playlists/normal-list.pls", mime_type="application/xspf+xml")

# Main requests queue from MyRadio Requests page
requests = request.queue(id="jukebox_requests")


def myradio_sched() =
    # Get the first line of the response
    result = list.hd(default="", get_process_lines(sched_script))
    # Create and return a request using this result
    request.create(result)
end

# The default track scheduler - obeys licence requirements
# and other funsies.
main = request.dynamic(id="jukebox_main", myradio_sched, timeout=15.0, conservative=true)

now_playing_id = ref ""
def update_now_playing(meta)
    now_playing_id := meta["trackid"]
end
main = on_metadata(update_now_playing, main)

def get_now_playing(_)
    !now_playing_id
end
server.register("now_playing", get_now_playing)

# Jingles every 15min~ish
jingles = playlist(reload_mode="watch", "/jukebox/jingles")
jingles = delay(900. , jingles)

# Campus Jukebox jingles every 30min
cjjingle = playlist(mode="randomize", reload=3600, "/jukebox/cj-jingles")
cjjingle = delay(1800., cjjingle)

# Put all the pieces together
jukebox = fallback([cjjingle, jingles, requests, main, backup_playlist], replay_metadata = false)
jukebox = fallback(track_sensitive=false, [jukebox, techlude])

# Avoid too much blank/silence in tracks
jukebox = skip_blank(max_blank=3., jukebox)

# Apply replay gain
jukebox = amplify(1.,override="replay_gain", jukebox)

jukebox = amplify(0.3, jukebox)

# Add in some crossfade
#jukebox = smart_crossfade(start_next=5., fade_in=3., fade_out=3., jukebox, conservative=true)
jukebox = crossfade(smart=true, duration=5., fade_in=3., fade_out=3., jukebox, conservative=true)

# Tracklist trigger
def trig_tracklist(j) =
        filename = j["filename"]
        ignore(system(tracklist_script ^ " " ^ string.quote (filename)))
end
jukebox = on_metadata(trig_tracklist, jukebox)

# Force Liq to separate Icecast metadata. 
def update_meta(m) =
	title = m["title"]
	artist = m["artist"]
	[("title","#{title}"),("artist","#{artist}")]
end

jukebox = map_metadata(update_meta, jukebox)

# Output to soundcards

output.jack(id="jukebox", start=true, jukebox)

# Icecast outputs use a seperate clock to remove lag from the HW output
clock.assign_new(id="jukeboxStream",
[
output.icecast(
    %mp3(bitrate=192, samplerate=48000, stereo=true),
    host=icehost,
    port=iceport,
    password=icepass,
    mount="jukebox",
    url=website,
    description=description,
    name=name,
    genre="Student Radio",
    mksafe(buffer(jukebox))
)
])
