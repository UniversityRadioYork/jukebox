#!/usr/bin/php

<?php
date_default_timezone_set('Europe/London');

$db_config = '/usr/local/etc/ury/urydb-silence';
$headers = 'From: Liquidsoap <liquidsoap@ury.org.uk>';

if (!file_exists($db_config)) {
    mail('alerts.uryfs1@ury.york.ac.uk', 'Silence Failure', 'The Silence Detector Database Configuration File does not exist', $headers);
} elseif (!file_exists('/tmp/silence_active_id')) {
    mail('alerts.uryfs1@ury.york.ac.uk', 'Silence Failure', 'A silence end event was detected but there was no active silence', $headers);
} else {
    $silenceid = file_get_contents('/tmp/silence_active_id');
    $connect = pg_connect(file_get_contents($db_config));
    pg_query_params($connect, 'UPDATE jukebox.silence_log SET stoptime=$2 WHERE silenceid=$1', array($silenceid, date('Y-m-d H:i:s')));
    unlink('/tmp/silence_active_id');
}

file_put_contents('/usr/local/var/log/blank_end.log', date('d/m/Y H:i:s')."\n", FILE_APPEND);
