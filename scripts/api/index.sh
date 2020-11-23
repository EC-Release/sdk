#!/bin/bash

{
    agent -ver
} || {
    print "\ncontinue agent installation\n\n"
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
}
printf "\n\nprint number of args %d. 0: %s 1: %s\n\n", $#, $0, $1

if [[ $# -gt 1 ]]; then
    agent $@
    exit 0
fi

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng.sh)
