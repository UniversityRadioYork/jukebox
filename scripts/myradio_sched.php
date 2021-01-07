#!/usr/bin/php
<?php
file_put_contents('/var/log/liquidsoap/timings.log', date('Y-m-d H:i:s') . " Started getting track\n", FILE_APPEND);
$time_start = microtime(true);

ini_set("allow_url_fopen", 1);
$config = parse_ini_file(__DIR__ . "/../conf/myradio_sched.ini");

// Ask the sequence controller what to play
@$json = file_get_contents($config["sequencer_url"]);
$obj = json_decode($json);
if ($obj && $obj->status == "OK") {
    if ($obj->payload->trackid == 0) {
        echo "annotate:trackid=\"0\":replay_gain:" . $obj->payload->path;
    } else {
        $trackid = $obj->payload->trackid; // 12345
        $recordid = $obj->payload->album->recordid;

        echo "annotate:recordid=\"" . $recordid . "\",trackid=\"" . $trackid . "\":replay_gain:/music/records/" . $recordid . "/" . $trackid . ".mp3";
    }
} else {
    // Ask MyRadio Directly
    $json = file_get_contents($config["api_url"] . "?api_key=" . $config["api_key"]);
    $obj = json_decode($json);
    $trackid = $obj->payload->trackid; // 12345
    $recordid = $obj->payload->album->recordid;

    echo "annotate:recordid=\"" . $recordid . "\",trackid=\"" . $trackid . "\":replay_gain:/music/records/" . $recordid . "/" . $trackid . ".mp3";
}

$time_end = microtime(true);
$time_taken = ($time_end - $time_start);

file_put_contents('/var/log/liquidsoap/timings.log', date('Y-m-d H:i:s') . ': ' . strval($time_taken) . " " . $trackid . ".mp3\n", FILE_APPEND);

//echo "/jukebox/cj-jingles/Jukebox 4 _9s_.wav\n";
//echo "/music/records/49735/106434.mp3\n"; #5ppm sine wave
//echo "/jukebox/intermission-long.mp3\n";
//echo "/jukebox/offlineLoop.wav";
?>
