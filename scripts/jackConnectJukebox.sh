#!/usr/bin/env bash

set -euo pipefail

jack_connect jukebox:out_0 system:playback_15
jack_connect jukebox:out_1 system:playback_16

jack_connect jukebox:out_0 selJukebox:in_0
jack_connect jukebox:out_1 selJukebox:in_1

jack_connect jukebox:out_0 fm-stl-jbox:input_1
jack_connect jukebox:out_1 fm-stl-jbox:input_2
