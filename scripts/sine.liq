input = sine()

input = amplify(.2, input)

# Output to soundcards
output.jack(id="sine", start=true, input)
