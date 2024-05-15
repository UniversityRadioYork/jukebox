#!/usr/bin/env bash

set -euo pipefail

MULTIPLEX=$(cat /usr/local/etc/liquidsoap/conf/dab.conf)
ICE_PASS=$(cat /usr/local/etc/liquidsoap/conf/ice.conf | grep icepass | cut -d "'" -f 2)

# Notes on these levels:
#	0.31 is -10dB (PPM 6)
#	3.1 is +10dB

odr-padenc --remove-dls --raw-slides --output=ury --dls=/opt/dab-pad/dab-pad.txt --dir=/opt/dab-pad/motsls &
sleep 2

odr-audioenc -j dab-mux-enc -b 48 --pad=16 --pad-socket=ury -l -o $MULTIPLEX  &
sleep 2

/home/michaelg/bin/ffmpeg \
	-re -hide_banner -loglevel warning \
	-f jack -i dab-tx-pgm -channels 2 \
	-f jack -i dab-tx-jbox -channels 2 \
	-f jack -i dab-tx-anews -channels 2 \
	-f jack -i dab-tx-alt -channels 2 \
	-filter_complex "[0]volume@s0=1[a];[1]volume@s1=0[b];[2]volume@s2=0[c];[3]volume@s3=0[d];[a][b][c][d]amix=inputs=4:normalize=false,azmq=bind_address=tcp\\\://0.0.0.0\\\:5556[tx];[tx]alimiter=limit=0.31:level=disabled:level_out=3.1,asplit[mux][mon]" \
	-map "[mon]" -f mp3 icecast://source:${ICE_PASS}@dolby.ury.york.ac.uk:7070/dab-send \
       	-map "[mux]" -f s16le pipe: | /home/marks/jack-stdio/jack-stdin -e signed -L -b 16 -n dab-mux-send dab-mux-enc:input0 dab-mux-enc:input1 &

sleep 2

jack_connect system:capture_3 dab-tx-pgm:input_1
jack_connect system:capture_4 dab-tx-pgm:input_2

jack_connect jukebox:out_0 dab-tx-jbox:input_1
jack_connect jukebox:out_1 dab-tx-jbox:input_2

jack_connect wspostanews:out_0 dab-tx-anews:input_1
jack_connect wspostanews:out_1 dab-tx-anews:input_2

wait
