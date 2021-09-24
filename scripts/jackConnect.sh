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
jack_connect obws_out:out_0 system:playback_5 # mraks.polakovs@ury.org.uk, 2020-09-26
jack_connect obws_out:out_1 system:playback_6
jack_connect ob:out_0 obws_ob:in_0
jack_connect ob:out_1 obws_ob:in_1
jack_connect selector:out_0 system:playback_1 #Selector to TX Compressor L
jack_connect selector:out_1 system:playback_2 #Selector to TX Compressor R
jack_connect system:capture_17 liveOutput:in_0 #TX Compressor to Online Streams L
jack_connect system:capture_18 liveOutput:in_1 #TX Compressor to Online Streams R
jack_connect system:capture_15 am:in_0
jack_connect system:capture_16 am:in_1

jack_connect system:capture_7 news:in_0 # IRN 1 (Main hourly news) is left channel
jack_connect system:capture_7 news:in_1
jack_connect system:capture_8 news2:in_0 # IRN 2 (Important events etc) is right channel
jack_connect system:capture_8 news2:in_1


# Leave WebStudio last - because, if services are started in the wrong order, these calls will fail
# - marks.polakovs@ury.org.uk 2020
# Commented out for new routes below
#jack_connect webstudio:out_0 directWebStudio:in_0
#jack_connect webstudio:out_1 directWebStudio:in_1
#jack_connect webstudio:out_0 selWS:in_0
#jack_connect webstudio:out_1 selWS:in_1

# New Routes for WS+AutoNews
jack_connect webstudio:out_0 wspreanews:in_0
jack_connect webstudio:out_1 wspreanews:in_1
jack_connect wspostanews:out_0 selWS:in_0
jack_connect wspostanews:out_1 selWS:in_1
jack_connect wspostanews:out_0 obws_ws:in_0
jack_connect wspostanews:out_1 obws_ws:in_1

#jack_connect sine:out_0 directWebStudio:in_0
#jack_connect sine:out_0 selWS:in_0
# Change the ones below to 2 once we have a second server.
#jack_connect webstudio:out_0 directWebStudioTwo:in_0
#jack_connect webstudio:out_1 directWebStudioTwo:in_1
#jack_connect webstudioOut:out_0 selWS:in_0
#jack_connect webstudioOut:out_1 selWS:in_1

#Isaac is determined to make all of the things cursed
jack_connect jukebox:out_0 stereo_tool:in_l
jack_connect jukebox:out_1 stereo_tool:in_r
jack_connect stereo_tool:out_l stool_out:in_0
jack_connect stereo_tool:out_r stool_out:in_1
