#!/bin/sh
#the capture inputs go scarlett Analogue 1-8 in, SPDIF 1-2 in, ADAT 1-8 mstratford-2019
# playbacks go Analogue 1-10 out, spdif 1-2 out, ADAT 1-8 out.
# Scarlett headphone ports are playback 7/8 and 9/10.

# Selector Sources
jack_connect system:capture_11 selStudio1:in_0
jack_connect system:capture_12 selStudio1:in_1

jack_connect system:capture_13 selStudio2:in_0
jack_connect system:capture_14 selStudio2:in_1

jack_connect ob:out_0 selOB:in_0
jack_connect ob:out_1 selOB:in_1

jack_connect wspostanews:out_0 selWS:in_0
jack_connect wspostanews:out_1 selWS:in_1

jack_connect sine:out_0 selSine:in_0
jack_connect sine:out_1 selSine:in_1

jack_connect offair:out_0 selOffAir:in_0
jack_connect offair:out_1 selOffAir:in_1

# TODO list
# - PGM outs should be from compressor
# - Remove/Replace AM Processing
# - Stereo FM Studio Link
# - Clean PGM Monitoring

# PGM Output
jack_connect selector:out_0 system:playback_1 #Selector to TX Compressor L
jack_connect selector:out_1 system:playback_2 #Selector to TX Compressor R

jack_connect selector:out_0 system:playback_3 #AM Compressor In (Monoing L)
jack_connect selector:out_1 system:playback_3 #AM Compressor In (Monoing R)

jack_connect selector:out_0 system:playback_4
jack_connect selector:out_1 system:playback_4

jack_connect selector:out_0 system:playback_13 # ADAT 1 -> Selector "Online" to studios
jack_connect selector:out_1 system:playback_14 # ADAT 2 // R

jack_connect selector:out_0 system:playback_5 # URYBlue Online Logger L
jack_connect selector:out_1 system:playback_6 # URYBlue Online Logger R

# Monitoring
jack_connect system:capture_5 system:playback_17 # ADAT 5 // AM Monoed
jack_connect system:capture_6 system:playback_17

jack_connect system:capture_7 system:playback_18 # ADAT 6 // FM Monoed
jack_connect system:capture_8 system:playback_18


jack_connect system:capture_5 system:playback_7 # Headphone AM Monitor
jack_connect system:capture_6 system:playback_8

jack_connect system:capture_7 system:playback_9 # Headphone FM Monitor
jack_connect system:capture_8 system:playback_10

# WS+AutoNews
jack_connect webstudio:out_0 wspreanews:in_0
jack_connect webstudio:out_1 wspreanews:in_1

# OBWS Feeds
jack_connect wspostanews:out_0 obws_ws:in_0
jack_connect wspostanews:out_1 obws_ws:in_1

jack_connect ob:out_0 obws_ob:in_0
jack_connect ob:out_1 obws_ob:in_1

jack_connect obws_out:out_0 system:playback_19
jack_connect obws_out:out_1 system:playback_20

# Jukebox
./jackConnectJukebox.sh
