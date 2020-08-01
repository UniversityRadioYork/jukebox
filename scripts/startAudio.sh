#!/bin/sh
sudo -u liquidsoap ./jackStart.sh &
sleep 2
sudo /etc/init.d/liquidsoap start
sleep 0.5
# marks.polakovs@ury.org.uk 2020
# Used to restart WebStudio audio receiver.
sudo systemctl restart shittyserver
sleep 0.5
sudo -u liquidsoap ./jackConnect.sh
