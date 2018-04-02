#!/usr/bin/php

<?php

$silencedisable = `head -n 1 /usr/local/etc/ury/silencedisable`;
$oldstate = intval(`/usr/local/bin/sel raw`);

$headers = 'From: Liquidsoap <liquidsoap@ury.org.uk>';

if ($silencedisable == 0){
    system('/usr/local/bin/sel 3');
    if($oldstate == 3) {
        mail('computing@ury.org.uk',
            'Critical Silence Alert (Jukebox)',
            'URY has been switched to Jukebox due to a breach of the silence threshold. At the time, Jukebox was on air.',
            $headers);
    } else {
        $to = ['chief.engineer@ury.org.uk', 'computing@ury.org.uk', 'pc@ury.org.uk'];
        $subject = '[URY] Silence Alert';
        $message = '30 seconds of silence was detected on live output. Source '.$oldstate.' was on air. Jukebox was automatically selected.';
        foreach ($to as $r) {
           mail($r, $subject, $message, $headers);
        }
    }
} elseif ($silencedisable == 1) {
    $to = ['computing@ury.org.uk'];
    $subject = '[URY] Silence Alert - Switch Disabled';
    $message = 'The silence threshold was breached, but auto-switch was disabled. Selector input remains on source '.$oldstate.'.';
    foreach ($to as $r) {
        mail($r, $subject, $message, $headers);
    }
}
