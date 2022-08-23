#!/bin/bash

/home/mstratford/ffmpeg_sources/ffmpeg_sources_git/ffmpeg -re -hide_banner -loglevel warning -f jack -i fm-stl -channels 2 -c:a pcm_s16be -f rtp -sdp_file /tmp/mem.sdp rtp://144.32.224.6:18830
