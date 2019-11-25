#!/usr/local/bin/liquidsoap -v

set("init.daemon.pidfile.path", "/usr/local/var/run/liquidsoap/sine.pid")
set("log.level",3)
set("log.stdout", true)
set("log.file", true)
set('log.file.path', '/usr/local/var/log/liquidsoap/sine.log')

input = sine()

input = amplify(.15, input)

# Output to soundcards
output.jack(id="sine", start=true, input)
