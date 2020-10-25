<?php

$config = parse_ini_file(__DIR__ . "/../conf/jukebox_jingles.ini");

@$json = file_get_contents($config["status_url"]);
$decode = json_decode($json);

if ($decode){
    echo ($decode->payload->sequencedShow ? "false":"true");
    // If a sequenced show -> don't do jukebox jingles
}else{
    echo "true";
    // Do jingles just to be safe
}

?>