#!/bin/sh
jack_disconnect sine:out_0 system:playback_3
jack_disconnect sine:out_1 system:playback_4
jack_disconnect sine:out_0 selJukebox:in_0
jack_disconnect sine:out_1 selJukebox:in_1
jack_disconnect sine:out_0 liveJukebox:in_0
jack_disconnect sine:out_1 liveJukebox:in_1
jack_connect jukebox:out_0 system:playback_3
jack_connect jukebox:out_1 system:playback_4
jack_connect jukebox:out_0 selJukebox:in_0
jack_connect jukebox:out_1 selJukebox:in_1
jack_connect jukebox:out_0 liveJukebox:in_0
jack_connect jukebox:out_1 liveJukebox:in_1
