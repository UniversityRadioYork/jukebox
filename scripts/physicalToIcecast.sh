#!/usr/bin/env bash

set -euo pipefail

publish () {
        local jack=$1;
        local mount=$2;
        local strm_name=$3;

        /home/michaelg/bin/ffmpeg -re -hide_banner \
                -f jack -i "${jack}" -channels 2 \
                -filter_complex "[0:a]ebur128=target=-16:video=1[vid][aud]" \
                -ice_genre "Student Radio" -ice_name "URY - ${strm_name}" -ice_description "Direct feed from ${strm_name}" -ice_url "https://ury.org.uk" \
                -f mp3 -map "[aud]" icecast://source:$(grep 'icepass' /usr/local/etc/liquidsoap/conf/ice.conf | cut -d "'" -f 2)@dolby.ury.york.ac.uk:7070/${mount} \
                -f null -map "[vid]" /dev/null
}

publish "fm" "fm" "FM" &
publish "news" "news" "IRN News 1" &
publish "news2" "news2" "IRN News 2" &
publish "directStudio1" "studio-red" "Studio Red" &
publish "directStudio2" "studio-blue" "Studio Blue" &

sleep 2

jack_connect system:capture_11 directStudio1:input_1
jack_connect system:capture_12 directStudio1:input_2

jack_connect system:capture_13 directStudio2:input_1
jack_connect system:capture_14 directStudio2:input_2

jack_connect system:capture_7 fm:input_1
jack_connect system:capture_8 fm:input_2

jack_connect system:capture_17 news:input_1 # IRN 1 (Main hourly news) is left channel
jack_connect system:capture_17 news:input_2

jack_connect system:capture_18 news2:input_1 # IRN 2 (Important events etc) is right channel
jack_connect system:capture_18 news2:input_2

wait
