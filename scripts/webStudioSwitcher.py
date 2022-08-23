#!/usr/bin/env python3
from telnetlib import Telnet
import subprocess
from datetime import datetime
import time
import sys
import requests
from pprint import pprint

OUTPUT = ("autonews:in_0", "autonews:in_1")
USE_LIVE_IN = True
SATELLITE = ("system:capture_17", "system:capture_17")


def do_jukebox_skip_telnet():
    HOST = "localhost"
    tn = Telnet("144.32.64.170",1234)
    tn.write("jukebox.skip\n")
    #tn.write(b"exit\n")

def do_ws_srv_telnet(source):
    HOST = "localhost"
    tn = Telnet(HOST,8078)
    tn.write(source + b"\n")
    #tn.write(b"exit\n")

def get_offset():
    # TODO this doesn't work
    t = datetime.now().time()
    return t.second + ((t.microsecond * 1.0) / 1e+6)


res = requests.get('https://ury.org.uk/webstudio/api/v1/nextTransition')
if not res.ok:
   print("And we failed to get api next transition.")
   sys.exit(1)
else:
   transition = res.json()["payload"]

pprint(transition)

source = transition["selSource"]
wsid = transition["wsSource"]

print("Starting switcher")

offset = get_offset()

if offset > 45:
    print("Something's gone terribly wrong!")
    sys.exit(1)

if not transition["autoNews"]:
   print("Not doing the news.")
   if transition["switchAudioAtMin"] == 0:
        print("Sleeping for {}".format(60.0-offset))
        time.sleep(60.0-offset)
   elif transition["switchAudioAtMin"] == 2:
        print("Sleeping for {}".format(60.0*3-offset))
        time.sleep(60.0*3-offset) # 2 mins from now
   if transition["wsSource"] !=  None:
        do_ws_srv_telnet(b"SEL " + str.encode(wsid))
   else:
        do_ws_srv_telnet(b"SEL NUL")
   #subprocess.Popen(["sel",str(transition["selSource"])]); - Commented for autoSelector replacement
   sys.exit(0)


else:
    print("Doing the news.")
    print("Sleeping for {}".format(43.0 - offset))
    time.sleep(43.0 - offset)

  #  print("Selecting 5")
   # switch_proc = subprocess.Popen(["sel","5"]); - Commented for autoSelector replacement
    time.sleep(3) # for 46 (with grace) secs past
    do_ws_srv_telnet(b"SEL NUL")
    #switch_proc = subprocess.Popen(["sel","5"]);

    # wait until 00:00
    offset = get_offset()
    print("Sleeping for {}".format(60.0 - offset))
    time.sleep(60.0 - offset)

    # wait until 02:02
    offset = get_offset()
    print("Sleeping for {}".format(122.0 - offset))
    time.sleep(122.0 - offset)

   # print("Selecting ", source)
    if wsid !=  None:
        do_ws_srv_telnet(b"SEL " + str.encode(wsid))
    else:
        do_ws_srv_telnet(b"SEL NUL")
    #do_ws_liq_telnet(b"selWS1")
    #if (source == 3):
    #    do_jukebox_skip_telnet()
   # switch_proc = subprocess.Popen(["sel",str(source)]); - Commented for autoSelector replacement
    #subprocess.run(["jack_disconnect", SATELLITE[1], OUTPUT[1]])

