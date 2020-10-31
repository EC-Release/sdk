#!/bin/bash
source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_pkg.txt)
~/.ec/conf/agent1.2beta.sh $@
