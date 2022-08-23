#!/usr/bin/php
<?php
date_default_timezone_set('Europe/London');

$db_config = '/usr/local/etc/ury/urydb-silence';
$headers = 'From: Liquidsoap <liquidsoap@ury.org.uk>';

if (!file_exists($db_config)) {
    mail('alerts.uryfs1@ury.org.uk', 'Silence Failure', 'The Silence Detector Database Configuration File does not exist', $headers);
} else {
    $connect = pg_connect(file_get_contents($db_config));
    $result = pg_fetch_row(pg_query_params($connect, 'INSERT INTO jukebox.silence_log (starttime) VALUES ($1) returning silenceid', array(date('Y-m-d H:i:s'))));
    $insertid = $result[0];
    file_put_contents('/tmp/silence_active_id', $insertid);
}

file_put_contents('/usr/local/var/log/blank.log', date('d/m/Y H:i:s')."\n", FILE_APPEND);
