#!/usr/local/bin/liquidsoap -v

%include "conf/sel.conf"
%include "conf/ice.conf"
#
# Streams for the Live output
#
set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/sel.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/sel.log')


set('server.telnet', true)
set('server.telnet.port', 1360)

# Set the OSC port to match TouchOSC's default port
set("osc.port", 8000)

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Selector sources (sel num)
# Studio1 (1), Studio2 (2), Jukebox (3), OB (4), Sine (7), Off-Air (8)
# Default to Off Air when starting Liq.
S1 = ref false
S2 = ref false
JB = ref false
OB = ref false
SI = ref false
OF = ref true

# Functions for reading Selector bools
def onS1 () =
    !S1
end
def onS2 () =
    !S2
end
def onOB () =
    !OB
end
def onJB () = 
    !JB
end
def onSI () =
    !SI
end
def onOF () =
    !OF
end

# Function for changing selector bools
# - returns string for telnet use as this is required
def selS1 (_) =
    S1 := true
    S2 := false
    JB := false
    OB := false
    SI := false
    OF := false
    "Studio 1 Selected"
end
def selS2 (_) =
    S1 := false
    S2 := true
    JB := false
    OB := false
    SI := false
    OF := false
    "Studio 2 Selected"
end
def selJB (_) =
    S1 := false
    S2 := false
    JB := true
    OB := false
    SI := false
    OF := false
    "Jukebox Selected"
end
def selOB (_) =
    S1 := false
    S2 := false
    JB := false
    OB := true
    SI := false
    OF := false
    "OB Stream Selected"
end
def selSI (_) =
    S1 := false
    S2 := false
    JB := false
    OB := false
    SI := true
    OF := false
    "Sine Wave Selected"
end
def selOF (_) = 
    S1 := false
    S2 := false
    JB := false
    OB := false
    SI := false
    OF := true
    "Off Air Selected"
end

# Enable selector functions on telnet
server.register("selJB", selJB)
server.register("selS1", selS1)
server.register("selS2", selS2)
server.register("selOB", selOB)
server.register("selSI", selSI)
server.register("selOF", selOF)

# OSC Function
# - take string and run selection based on that
# - ignore() turns function returning string to unit
def sel(s) =
    if s == "S1" then
        ignore(selS1())
    elsif s == "S2" then
        ignore(selS2())
    elsif s == "JB" then
        ignore(selJB())
    elsif s == "OB" then
        ignore(selOB())
    elsif s == "SI" then
        ignore(selSI())
    elsif s == "OF" then
	ignore(selOF())
    end
end

# Setup OSC hook for /sel/XX
osc.on_string("/sel", sel)

# A simple cross-fade for transitions
def crossswitch(a,b)
    add(
        normalize=false,
        [
            sequence([
                    #blank(duration=.1),
                    fade.initial(duration=.2,b)
            ]),
            fade.final(duration=.2,a)
        ]
    )
end


# Blank detection system
def blankHandler()
    system(blankscript)
end

def blankEndHandler()
    system(blankendscript)
end

def blankCritHandler()
    system(criticalblankscript)
end


# Sources
studio1 = input.jack(id="selStudio1")
studio2 = input.jack(id="selStudio2")
jukebox = input.jack(id="selJukebox")
ob = input.jack(id="selOB")
sine = input.jack(id="selSine")
offair = input.jack(id="selOffAir")

# Selector Handlers

selector = switch(
    track_sensitive=false,
    transitions=[
        crossswitch,
        crossswitch,
        crossswitch,
        crossswitch,
	crossswitch,
	crossswitch
    ],
    [
        (onS1, studio1),
        (onS2, studio2),
        (onJB, jukebox),
        (onOB, ob),
	(onSI, sine),
	(onOF, offair)
    ]
)

selector = amplify(0.85, selector)

selector = on_blank(threshold=-55., max_blank=2., min_noise=1., on_noise=blankEndHandler, blankHandler, selector)
selector = on_blank(threshold=-55., max_blank=30., blankCritHandler, selector)

selector = mksafe(selector)

output.jack(id="selector", selector)

#clock.assign_new(id="studio1Stream",
#    [
  #  output.icecast(
  #      %mp3(bitrate=192),
  #      host=icehost,
  #      port=iceport,
  #      password=icepass,
  #      mount="studio-red",
  #      url=website,
  #      description="Direct feed from Studio Red",
  #      name="URY Studio Red",
  #      genre="Student Radio",
 ##       studio1
 #   )
    #]
#)

#clock.assign_new(id="studio2Stream",
    #[
  #  output.icecast(
  #      %mp3(bitrate=192),
  #      host=icehost,
  #      port=iceport,
  #      password=icepass,
  #      mount="studio-blue",
  #      url=website,
  #      description="Direct feed from Studio Blue",
  #      name="URY Studio Blue",
   #     genre="Student Radio",
 #       studio2
#    )
    #]
#)
