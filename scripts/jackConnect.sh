#!/bin/sh
jack_connect system:capture_1 selStudio1:in_0
jack_connect system:capture_2 selStudio1:in_1
jack_connect system:capture_3 selStudio2:in_0
jack_connect system:capture_4 selStudio2:in_1
jack_connect system:capture_1 directStudio1:in_0
jack_connect system:capture_2 directStudio1:in_1
jack_connect system:capture_3 directStudio2:in_0
jack_connect system:capture_4 directStudio2:in_1
jack_connect jukebox:out_0 system:playback_3
jack_connect jukebox:out_1 system:playback_4
jack_connect jukebox:out_0 selJukebox:in_0
jack_connect jukebox:out_1 selJukebox:in_1
jack_connect jukebox:out_0 liveJukebox:in_0
jack_connect jukebox:out_1 liveJukebox:in_1
jack_connect sine:out_0 selSine:in_0
jack_connect sine:out_1 selSine:in_1
jack_connect offair:out_0 selOffAir:in_0
jack_connect offair:out_1 selOffAir:in_1
jack_connect ob:out_0 system:playback_5
jack_connect ob:out_1 system:playback_6
jack_connect ob:out_0 selOB:in_0
jack_connect ob:out_1 selOB:in_1
jack_connect selector:out_0 system:playback_1 #Selector to TX Compressor L
jack_connect selector:out_1 system:playback_2 #Selector to TX Compressor R
jack_connect system:capture_17 liveOutput:in_0 #TX Compressor to Online Streams L
jack_connect system:capture_18 liveOutput:in_1 #TX Compressor to Online Streams R
jack_connect system:capture_15 am:in_0
jack_connect system:capture_16 am:in_1
jack_connect system:capture_7 news:in_0
jack_connect system:capture_8 news:in_1


# Leave WebStudio last - because, if services are started in the wrong order, these calls will fail
# - marks.polakovs@ury.org.uk 2020
# New Routes for WS+AutoNews
jack_connect webstudio:out_0 wspreanews:in_0
jack_connect webstudio:out_1 wspreanews:in_1
jack_connect wspostanews:out_0 selWS:in_0
jack_connect wspostanews:out_1 selWS:in_1
