#!/bin/bash

if [ $# -ne 3 ]; then
    echo "$0: usage: ob_disconnect.sh <source> <state_file> <email_state>"
    exit 1
fi

state = $1
state_file = $2
email_state = $3

source $state_file

if [ $email_state -eq 1 ]; then
  echo "Outside Broadcast Source $1 has disconnected." | mail -s "[RouteOB] Stream Lost" "alerts.audioroute@ury.org.uk";
fi

declare $1=0;

echo "s1=$s1
s2=$s2
s3=$s3" > $state_file
