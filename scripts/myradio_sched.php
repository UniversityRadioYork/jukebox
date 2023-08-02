#!/usr/bin/php
<?php

ini_set("allow_url_fopen", 1);
$config = parse_ini_file(__DIR__ . "/../conf/myradio_sched.ini");

	// Ask MyRadio Directly
	$json = file_get_contents($config["api_url"] . "?api_key=" . $config["api_key"]);
	$obj = json_decode($json);
	$trackid = $obj->payload->trackid; // 12345
	$recordid = $obj->payload->album->recordid;

	$file = "/music/records/". $recordid ."/" . $trackid . ".mp3";
	$newfile = "/music-jukebox-tmp/". $recordid ."-" . $trackid . ".mp3";


	//if (!copy($file, $newfile)) {
    	//	echo "failed to copy $file...\n";
	//}

	//echo "annotate:recordid=\"" . $recordid . "\",trackid=\"" . $trackid . "\":replay_gain:".$newfile;
        echo "annotate:recordid=\"" . $recordid . "\",trackid=\"" . $trackid . "\":replay_gain:".$file;
?>
