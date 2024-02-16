#!/usr/bin/env bash

set -euo pipefail

OUTPUT="icecast://source:$(grep 'icepass' /usr/local/etc/liquidsoap/conf/ice.conf | cut -d "'"     -f 2)@dolby.ury.york.ac.uk:7070"
ICE_FLAGS="-ice_genre 'Student Radio' -ice_description 'The UK\'s oldest legal independent radio station.' -ice_url 'https://ury.org.uk'"

/home/michaelg/bin/ffmpeg -hide_banner \
	-f jack -i "liveOutput" -channels 2 \
	-filter_complex "TODO" \
	-f mp3 -b:a 192k $ICE_FLAGS -ice_name "University Radio York - High Quality" $OUTPUT/live-high \
	-f mp3 -b:a 48k $ICE_FLAGS -ice_name "University Radio York - Mobile" $OUTPUT/live-mobile \
	-f ogg -b:a 128k $ICE_FLAGS -ice_name "University Radio York - OGG Stream" -content_type audio/ogg $OUTPUT/live-high-ogg \
	-f ogg -c:a flac $ICE_FLAGS -ice_name "University Radio York - FLAC Stream" -content_type audio/ogg $OUTPUT/live-high-flac &

sleep 2

jack_connect system:capture_3 liveOutput:input_1 #TX Compressor to Online Streams L
jack_connect system:capture_4 liveOutput:input_2 #TX Compressor to Online Streams R

wait
