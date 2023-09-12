#!/usr/bin/env bash

set -euo pipefail

# The capture inputs go Scarlett Analogue 1-8 in, SPDIF 1-2 in, ADAT 1-8 mstratford-2019
# Playbacks go Analogue 1-10 out, spdif 1-2 out, ADAT 1-8 out.
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

# PGM Output
jack_connect selector:out_0 system:playback_1 #Selector to TX Compressor L
jack_connect selector:out_1 system:playback_2 #Selector to TX Compressor R

# Logging
jack_connect system:capture_3 system:playback_5 # URYBlue Online Logger L
jack_connect system:capture_4 system:playback_6 # URYBlue Online Logger R

jack_connect system:capture_7 system:playback_3 # FM Receiver -> URYRed L
jack_connect system:capture_8 system:playback_4 # FM Receiver -> URYRed L

# Monitoring
jack_connect system:capture_3 system:playback_13 # PGM -> Studios L
jack_connect system:capture_4 system:playback_14 # PGM -> Studios R

jack_connect system:capture_7 system:playback_17 # FM Receiver -> Studios
jack_connect system:capture_8 system:playback_18

# Headphones
jack_connect system:capture_3 system:playback_7 # Headphone PGM Monitor
jack_connect system:capture_4 system:playback_8

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
