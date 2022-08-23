#!/bin/sh
eval `dbus-launch --auto-syntax`
export DBUS_SESSION_BUS_PID DBUS_SESSION_BUS_ADDRESS
/usr/bin/jackd -t200 -dalsa -dhw:USB,0 -r48000 -p1024 -n2
