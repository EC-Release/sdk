#!/bin/bash
exec env --ignore-environment /bin/bash
export TERM=xterm-color
#base64 | tr -d \\n
stty rows 40 cols 120
/bin/bash -l
