#!/bin/sh
sudo -u liquidsoap /usr/local/bin/jackStart.sh &
sleep 2
sudo /etc/init.d/liquidsoap start
sleep 2
sudo -u liquidsoap /usr/local/bin/jackConnect.sh
