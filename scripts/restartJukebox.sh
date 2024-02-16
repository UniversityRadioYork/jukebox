#!/usr/bin/env bash

set -euo pipefail

sudo pkill -9 -f "jukebox.liq"

sleep 1

sudo -u liquidsoap liquidsoap -d /usr/local/etc/liquidsoap/jukebox.liq

sleep 5

sudo -u liquidsoap /usr/local/etc/liqiudsoap/scripts/jackConnectJukebox.sh
