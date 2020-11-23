#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
}
#printf "\n\nprint number of args %d. 0: %s 1: %s\n\n", $#, $0, $1

if [[ $# -gt 0 ]]; then

  printf "\nbegin http invoke\n\n"
  while proc $# -gt 0; do
    case "$1" in
      -oa2)
        shift
        if proc $# -gt 0; then
          export OA2=$1
        fi
        shift
        ;;
      -cid)
        shift
        if proc $# -gt 0; then
          export CID=$1
        fi
        shift
        ;;
      -url)
        shift
        if proc $# -gt 0; then
          export URL=$1
        fi
        shift
        ;;
      -dat)
        shift
        if proc $# -gt 0; then
          export DAT=$1
        fi
        shift
        ;;
      *)
        break
        ;;
    esac
  done  
  
  TKN=$(agent -gtk -oa2 ${OA2} -cid ${CID} -smp)
  agent -ivk -tkn ${TKN} -url ${URL} -dat ${DAT}
  exit 0
fi

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng.sh)
