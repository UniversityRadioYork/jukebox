#!/bin/sh
jack_disconnect system:capture_3 fm-stl:input_1 # Compressor -> FM
jack_disconnect system:capture_4 fm-stl:input_2 

jack_connect jukebox:out_0 fm-stl:input_1
jack_connect jukebox:out_1 fm-stl:input_2
