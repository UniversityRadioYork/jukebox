#!/usr/bin/env bash

set -eo pipefail
srt-live-transmit -v srt://nas.mstratford.net:1200?mode=caller file://con | /home/mstratford/ffmpeg_sources/ffmpeg_sources_git/ffmpeg -hide_banner -loglevel warning -i pipe: -c:a pcm_s16le -f s16le pipe: | /home/marks/jack-stdio/jack-stdin -e signed -L -b 16 -n stratnews news:in_1
