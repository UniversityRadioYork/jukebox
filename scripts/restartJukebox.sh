#!/bin/sh
sudo pkill -9 -f "jukebox.liq"
sleep 1
sudo -i -u liquidsoap bash << EOF
 liquidsoap -d /usr/local/etc/liquidsoap/jukebox.liq &
sleep 5
jack_connect jukebox:out_0 system:playback_15
jack_connect jukebox:out_1 system:playback_16
jack_connect jukebox:out_0 selJukebox:in_0
jack_connect jukebox:out_1 selJukebox:in_1
jack_connect jukebox:out_0 liveJukebox:in_0
jack_connect jukebox:out_1 liveJukebox:in_1
jack_connect jukebox:out_0 fm-stl-jbox:input_1
jack_connect jukebox:out_1 fm-stl-jbox:input_2
EOF
