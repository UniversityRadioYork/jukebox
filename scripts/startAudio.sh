#!/bin/sh
#sudo -u liquidsoap ./jackStart.sh &
#/usr/local/etc/liquidsoap/scripts/jackStart.sh &
echo Starting JACK
sudo service ury-jack start
sleep 10
#sudo /etc/init.d/liquidsoap start
echo Fixing WS pidfile permissions...
sudo chmod 664 /usr/local/var/run/liquidsoap/*.pid
echo Starting Liquidsoap
sudo /etc/init.d/liquidsoap start
sleep 2
# marks.polakovs@ury.org.uk 2020
echo Restarting WS shittyserver
sudo systemctl restart shittyserver
sleep 2

echo Starting FM Streamer # must be done before jack connections
sudo systemctl restart fm-streamer
sleep 2

echo Starting DAB Streamer
sudo systemctl restart dab-streamer
sleep 2

echo jackConnecting
sudo -u liquidsoap ./jackConnect.sh
#/usr/local/etc/liquidsoap/scripts/jackConnect.sh
#sudo service dearie-me restart
