#!/bin/sh
#jack_disconnect jukebox:out_0 fm-stl:input_1
#jack_disconnect jukebox:out_1 fm-stl:input_2

#jack_connect system:capture_3 fm-stl:input_1 # Compressor -> FM
#jack_connect system:capture_4 fm-stl:input_2 
echo "this is the old way, maybe you want curl -X POST -d source=0 localhost:5001/source"
