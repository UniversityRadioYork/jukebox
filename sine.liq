#!/usr/local/bin/liquidsoap -v

input = sine()

input = amplify(.15, input)

# Output to soundcards
output.jack(id="sine", start=true, input)
