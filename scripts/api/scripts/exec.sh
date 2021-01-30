#!/bin/bash

#exec 0<&-

#base64 | tr -d \\n
stty rows 40 cols 120
#/bin/bash -l

wget -q --show-progress -O ~/.ec/scripts/exec-bootstrap.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/exec-bootstrap.sh
chmod +x ~/.ec/scripts/exec-bootstrap.sh
source ~/.ec/scripts/exec-bootstrap.sh "$@"
