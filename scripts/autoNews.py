#!/usr/bin/env python3
import requests
import subprocess
from datetime import datetime
import time
import sys

OUTPUT = ("autonews:in_0", "autonews:in_1")
USE_LIVE_IN = True
SATELLITE = ("system:capture_17", "system:capture_17") ## ("stratnews:input1", "stratnews:input1")


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

if not transition["autoNews"]:
   print("AutoNews was False, not doing news")
   sys.exit(0)

print("Starting news")

offset = get_offset()

if offset > 45:
    print("Something's gone terribly wrong!")
    sys.exit(1)

print("Sleeping for {}".format(40.0 - offset))
time.sleep(40.0 - offset)

print("Starting mpv")
jingle_proc = subprocess.Popen(
        ["mpv", "--ao=jack", "--jack-connect=yes", "--jack-port=autonews:in_(0|1)", "--jack-name=news_jingle", "--quiet", "jingle_5secintro_v6FM2.wav"]
)
## this jingle has a 5 second silence intro, give us 3 secs for mpv to start (generous), leaving 2 secs for jack to connect before jingle.
## temporarily disabled - marks.polakovs@ury.org.uk
#time.sleep(3)
#subprocess.run(["jack_connect", "news_jingle:out_0", OUTPUT[0]])
#subprocess.run(["jack_connect", "news_jingle:out_1", OUTPUT[1]])

offset = get_offset()
print("Sleeping for {}".format(60.0 - offset))
time.sleep(60.0 - offset)

if USE_LIVE_IN:
    print("Connecting satellite")
    subprocess.run(["jack_connect", SATELLITE[0], OUTPUT[0]])
    subprocess.run(["jack_connect", SATELLITE[1], OUTPUT[1]])
else:
    print("Starting mpv 2")
    news_proc = subprocess.Popen(
            ["mpv", "--ao=jack", "--jack-connect=yes", "--jack-port=autonews:in_(0|1)", "--jack-name=test_news", "snrnews.mp3"]
    )

    #time.sleep(1)
    #subprocess.run(["jack_connect", "test_news:out_0", OUTPUT[0]])
    #subprocess.run(["jack_connect", "test_news:out_1", OUTPUT[1]])
    ## things with ## are marks.polakovs experimenting
##    time.sleep(0.5)
##    subprocess.run(["jack_connect", "test_news:out_0", OUTPUT[0]])
##    subprocess.run(["jack_connect", "test_news:out_0", OUTPUT[1]]) # it's a mono file
    #do the first run quickly, if that fails, try again.
##    time.sleep(0.5)
##    subprocess.run(["jack_connect", "test_news:out_0", OUTPUT[0]])
##    subprocess.run(["jack_connect", "test_news:out_0", OUTPUT[1]]) # it's a mono file

offset = get_offset()
print("Sleeping for {}".format(122.0 - offset))
time.sleep(124.0 - offset)

if USE_LIVE_IN:
    print("Disconnecting satellite")
    subprocess.run(["jack_disconnect", SATELLITE[0], OUTPUT[0]])
    subprocess.run(["jack_disconnect", SATELLITE[1], OUTPUT[1]])

time.sleep(5) # just a bit more time,  news jingle may still be playing?

exit()
