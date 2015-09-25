#
# Streams for the Live output
#
set("log.level",3)
set("log.stdout", true)
set("log.file", false)
set('log.file.path', '/usr/local/var/log/liquidsoap/live.log')


set('server.telnet', true)
set('server.telnet.port', 1360)

# Set the OSC port to match TouchOSC's default port
set("osc.port", 8000)

set("frame.audio.channels",2)
set("frame.audio.samplerate",48000)

# Selector bools
S1 = ref false
S2 = ref false
OB = ref false

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

# Function for changing selector bools
# - returns string for telnet use as this is required
def selJB (_) =
	S1 := false
	S2 := false
	OB := false
	"Jukebox Selected"
end
def selS1 (_) =
	S1 := true
	S2 := false
	OB := false
	"Studio 1 Selected"
end
def selS2 (_) =
	S1 := false
	S2 := true
	OB := false
	"Studio 2 Selected"
end
def selOB (_) =
	S1 := false
	S2 := false
	OB := true
	"OB Stream Selected"
end

# Enable selector functions on telnet
server.register("selJB", selJB)
server.register("selS1", selS1)
server.register("selS2", selS2)
server.register("selOB", selOB)

# OSC Function
# - take string and run selection based on that
# - ignore() turns function returning string to unit
def sel(s) = 
	if s == "JB" then
		ignore(selJB())
	elsif s == "S1" then
		ignore(selS1())
	elsif s == "S2" then
		ignore(selS2())
	elsif s == "OB" then
		ignore(selOB())
	end
end

# Setup OSC hook for /sel/XX
osc.on_string("/sel", sel)


# Sources
studio1 = input.alsa(device="pcm.stereo0In")
studio2 = input.alsa(device="pcm.stereo1In")
jukebox = input.alsa(device="pcm.stereo4In")
ob = input.alsa(device="pcm.stereo5In")

# Selector Handlers

selector = switch(
	track_sensitive=false,
	[
		(onS1, studio1),
		(onS2, studio2),
		(onOB, ob),
		({true}, jukebox)
	]
)

output.alsa(device="pcm.stereo0Out", bufferize=false, fallible=true, selector)
