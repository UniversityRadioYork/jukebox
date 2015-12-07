#!/bin/sh
sudo -u liquidsoap ./jackStart.sh &
sleep 2
sudo /etc/init.d/liquidsoap start
sleep 2
sudo -u liquidsoap ./jackConnect.sh
