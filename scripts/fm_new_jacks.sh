#!/bin/sh
jack_connect system:capture_3 fm-stl-pgm:input_1 # Compressor -> FM
jack_connect system:capture_4 fm-stl-pgm:input_2 

jack_connect jukebox:out_0 fm-stl-jbox:input_1
jack_connect jukebox:out_1 fm-stl-jbox:input_2

jack_connect wspostanews:out_0 fm-stl-anews:input_1
jack_connect wspostanews:out_1 fm-stl-anews:input_2
