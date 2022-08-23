#!/bin/sh
jack_disconnect jukebox:out_0 system:playback_3
jack_disconnect jukebox:out_1 system:playback_4
jack_disconnect jukebox:out_0 selJukebox:in_0
jack_disconnect jukebox:out_1 selJukebox:in_1
jack_disconnect jukebox:out_0 liveJukebox:in_0
jack_disconnect jukebox:out_1 liveJukebox:in_1
jack_connect sine:out_0 system:playback_3
jack_connect sine:out_1 system:playback_4
jack_connect sine:out_0 selJukebox:in_0
jack_connect sine:out_1 selJukebox:in_1
jack_connect sine:out_0 liveJukebox:in_0
jack_connect sine:out_1 liveJukebox:in_1
