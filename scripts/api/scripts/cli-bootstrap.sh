#!/bin/bash
#rm -Rf ~/.ec/script/cli-bootstrap.sh ~/.ec/script/exec-bootstrap.sh
exec env --ignore-environment /bin/bash -l

source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.linux64.txt) -ver
