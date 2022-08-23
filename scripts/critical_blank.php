<<<<<<< HEAD
#!/usr/bin/php

<?php

$silencedisable = `head -n 1 /usr/local/etc/ury/silencedisable`;
$oldstate = intval(`/usr/local/bin/sel raw`);

$headers = 'From: Liquidsoap <liquidsoap@ury.org.uk>';

if ($silencedisable == 0){
    system('/usr/local/bin/sel 3');
    if($oldstate == 3) {
        $to = ['computing@ury.org.uk'];
        $subject = '[URY] Silence Alert (Jukebox)';
        $message = 'URY has been switched to Jukebox due to a breach of the silence threshold. At the time, Jukebox was on air.';
    } else {
        $to = ['chief.engineer@ury.org.uk', 'computing@ury.org.uk', 'pc@ury.org.uk'];
        $subject = '[URY] Silence Alert';
        $message = '30 seconds of silence was detected on live output. Source '.$oldstate.' was on air. Jukebox was automatically selected.';
    }
} elseif ($silencedisable == 1) {
    $to = ['computing@ury.org.uk'];
    $subject = '[URY] Silence Alert - Switch Disabled';
    $message = 'The silence threshold was breached, but auto-switch was disabled. Selector input remains on source '.$oldstate.'.';
} else {
    exit;
}

foreach ($to as $r) {
    mail($r, $subject, $message, $headers);
}

if (file_exists(__DIR__ . '/../conf/slack.ini')) {
    ini_set("allow_url_fopen", 1);
    $config = parse_ini_file(__DIR__ . "/../conf/slack.ini");

    $c = curl_init($config['webhook_url']);
    curl_setopt($c, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($c, CURLOPT_POST, true);
    curl_setopt($c, CURLOPT_POSTFIELDS, [
      'payload' => json_encode([
        'text' => $message
      ])
    ]);
    curl_exec($c);
    curl_close($c);
}

