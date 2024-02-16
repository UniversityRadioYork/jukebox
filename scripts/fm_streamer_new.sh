#!/usr/bin/env bash

/home/michaelg/bin/ffmpeg \
		-re  `# read input at native rate` \
		-hide_banner `# hide copyright notices etc.` \
		-loglevel warning `# sets log level to warnings or above` \
		-f jack -i fm-stl-pgm -channels 2 `# jack input from jack fm-stl with 2 audio channels` \
		-f jack -i fm-stl-jbox -channels 2 \
		-f jack -i fm-stl-anews -channels 2 \
		-c:a pcm_s16be `# audio codec` \
		-filter_complex "[0]volume@s0=1[a];[1]volume@s1=0[b];[2]volume@s2=0[c];[a][b][c]amix=inputs=3:normalize=false,azmq" \
		-f rtp  `# output format (rtp stream)` \
		-sdp_file /tmp/mem.sdp `# session description protocol logging file` \
		rtp://144.32.224.6:18830 `# fmstl pi` &

sleep 2
/usr/local/etc/liquidsoap/scripts/fm_new_jacks.sh

wait


