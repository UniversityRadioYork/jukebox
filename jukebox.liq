#!/usr/local/bin/liquidsoap -v

# Coded by Gareth Lloyd <gareth@ignition-web.co.uk>
# & Lloyd Wallis <flump5281@gmail.com>
# & Andy Durant <andy@ajdurant.co.uk>
# Launched on URY 2012-01-27 00:36
%include "ice.conf"
%include "jukebox.conf"

set("log.stdout",true)
set("log.level",3)
set("server.telnet.bind_addr", telnetaddr)
set("server.telnet", true)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/jukebox.log")

# Local file if music filestore isn't
interludelong = mksafe(single("/jukebox/intermission-long.mp3"))
interludelong = crossfade(start_next=2., fade_in=1.2, fade_out=1.2, interludelong)
techdiff = single("/jukebox/TechnicalDifficultiesVoice.mp3")
techlude = add([interludelong, switch([({0s}, techdiff)])])

# Playlists - used if MyRadio script breaks
# A list
alist = playlist(reload_mode="watch", "/jukebox/playlists/a-list.pls", mime_type="application/xspf+xml")
# B list
blist = playlist(reload_mode="watch", "/jukebox/playlists/b-list.pls", mime_type="application/xspf+xml")
# C list
clist = playlist(reload_mode="watch", "/jukebox/playlists/c-list.pls", mime_type="application/xspf+xml")

# Normal playlist
default = playlist(reload_mode="watch", "/jukebox/playlists/normal-list.pls", mime_type="application/xspf+xml")

# Main requests queue from MyRadio Requests page
requests = request.queue(id="jukebox_requests")

# Watershed only between 11pm and 4am
watershed = playlist(mode="randomize", "/jukebox/playlists/watershed.pls", mime_type="application/xspf+xml")

playlists_day = random(weights=[2, 1, 1, 2], [alist, blist, clist, default])
playlists_night = random(weights=[2, 1, 1, 2, 1], [alist, blist, clist, default, watershed])

playlists = switch([({23h-4h}, playlists_night), ({4h-23h}, playlists_day)])

def myradio_sched() = 
  # Get the first line of the response
  result =
    list.hd(
      get_process_lines(sched_script))
  # Create and return a request using this result
  request.create(result)
end

# The default track scheduler - obeys licence requirements
# and other funsies.
main = request.dynamic(id="jukebox_main", myradio_sched)

# Jingles every 15min~ish
jingles = playlist(reload_mode="watch", "/jukebox/jingles")
jingles = delay(900. , jingles)

# Campus Jukebox jingles every 30min
cjjingle = playlist(mode="randomize", reload=3600, "/jukebox/cj-jingles")
cjjingle = delay(1800., cjjingle)

# Put all the pieces together
jukebox = fallback([cjjingle, jingles, requests, main, playlists])
jukebox = fallback(track_sensitive=false, [jukebox, techlude])

# Avoid too much blank/silence in tracks
jukebox = skip_blank(max_blank=3., jukebox)

# Apply replay gain
jukebox = amplify(1.,override="replay_gain", jukebox)

jukebox = amplify(0.2, jukebox)

# Add in some crossfade
jukebox = smart_crossfade(start_next=5., fade_in=3., fade_out=3., jukebox, conservative=true)

# Tracklist trigger
def trig_tracklist(j) =
        filename = j["filename"]
        system(tracklist_script ^ " " ^ quote (filename))
end
jukebox = on_metadata(trig_tracklist, jukebox)

# Output to soundcards
output.alsa(device="pcm.stereo1Out", jukebox, start=true)

# Icecast outputs use a seperate clock to remove lag from the ALSA output
clock.assign_new(id="jukebox",
[output.icecast(
		%mp3(bitrate=192, samplerate=44100, stereo=true),
		host=icehost,
		port=iceport,
		password=icepass,
		mount="jukebox",
		url=website,
		description=description,
		name=name,
		genre="Student Radio",
		mksafe(buffer(jukebox)))])
