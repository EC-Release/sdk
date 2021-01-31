#!/bin/bash
exec env --ignore-environment /bin/bash -l
export TERM=xterm-color
#base64 | tr -d \\n
stty rows 40 cols 120
print "\n\nhello"
#/bin/bash -l
