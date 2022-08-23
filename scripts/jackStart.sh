#!/bin/sh
eval `dbus-launch --auto-syntax`
export DBUS_SESSION_BUS_PID DBUS_SESSION_BUS_ADDRESS
export DISPLAY=:0 

/usr/bin/jackd -t5000 -R -dalsa -dhw:USB -r48000 -n3
