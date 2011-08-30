#!/usr/bin/liquidsoap -v

jingles = playlist(mode='random', './jingles/')
adverts = playlist(mode='random', './adverts/')
chart   = playlist(mode='random', './chart/')
songs   = playlist(mode='random', './songs/')

s = random(weights=[2,1,5,12], [jingles, adverts, chart, songs])
s = strip_blank(s)
s = smart_crossfade(s)

out(s)
