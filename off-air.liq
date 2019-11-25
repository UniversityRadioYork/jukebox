#!/usr/local/bin/liquidsoap -v

# Based on jukebox.liq
# Off Air Loop script by Matthew Stratford <matthew.stratford@ury.org.uk>
# Launched on URY Tue 27-03-2018

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/off-air.pid")
set("log.stdout",true)
set("log.level",3)
set("log.file", true)
set("log.file.path","/usr/local/var/log/liquidsoap/off-air.log")

# That loop that is ever so catchy, right?!
offlineLoop = mksafe(single("/jukebox/offlineLoop.wav"))

# Jingles every 1min~ish
jingles = playlist(reload_mode="watch", "/jukebox/jingles")
jingles = delay(60. , jingles)

#jingles = smart_crossfade(start_next=1., fade_in=1., fade_out=1., jingles, conservative=true)

offlineLoop = amplify(0.70,offlineLoop)

# A simple cross-fade for transitions
def crossswitch(a,b)
    add(
        normalize=true,
        [
            sequence([
                    #blank(duration=.1),
                    fade.initial(duration=1.0,b)
            ]),
            fade.final(duration=1.0,a)
        ]
    )
end

# Put all the pieces together
offair = fallback(transitions=[crossswitch],[jingles, offlineLoop])

# Avoid too much blank/silence between jingles and offline loop.
offair = skip_blank(max_blank=1., offair)

offair = amplify(0.3, offair)

# Output to soundcards
output.jack(id="offair", start=true, offair)
