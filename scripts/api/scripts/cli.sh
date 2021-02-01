#!/bin/bash
#exec env --ignore-environment /bin/bash -l
export TERM=xterm-color
#base64 | tr -d \\n
stty rows 40 cols 120
#print "\n\nhello"
#/bin/bash -l

ln -s ~/.ec/agt/bin/${AGENT_REV_LOCAL} /bin/agent

wget -q --show-progress -O ~/.ec/scripts/cli-bootstrap.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/cli-bootstrap.sh
chmod +x ~/.ec/scripts/cli-bootstrap.sh

exec env --ignore-environment /root/.ec/scripts/cli-bootstrap.sh "$@"
