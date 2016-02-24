#!/usr/bin/php

<?php

$silencedisable = `head -n 1 /usr/local/etc/ury/silencedisable`;
$oldstate = `/usr/local/bin/sel raw`;

$headers = 'From: Liquidsoap <liquidsoap@ury.org.uk>';

if ($silencedisable == 0){
    system('/usr/local/bin/sel 3');
    if($oldstate == 3) {
        mail('computing@ury.org.uk',
            'Critical Silence Alert (Jukebox)',
            'URY has been switched to jukebox due to a breach of the silence threshold. At the time, jukebox was on-air.',
            $headers);
    } else {
        $to = ['chief.engineer@ury.org.uk', 'computing@ury.org.uk', 'pc@ury.org.uk'];
        $subject = '[URY] Silence Alert';
        $message = '30 seconds of quiet output has been detected on the web stream. Jukebox has been automatically put to air.';
        foreach ($to as $r) {
            mail($r, $subject, $message, $headers);
        }
    }
} elseif ($silencedisable == 1) {
    $to = ['chief.engineer@ury.org.uk', 'computing@ury.org.uk'];
    $subject = '[URY] Silence Alert - Switch Disabled';
    $message = 'The silence threshold was breached, but auto-switch was disabled. (Selector input remains on $oldstate)';
    foreach ($to as $r) {
        mail($r, $subject, $message, $headers);
    }
}
