#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
}

if [[ $# -gt 1 ]]; then

  while test $# -gt 1; do
    case "$1" in
      -oa2)
        shift
        if test $# -gt 0; then
          export OA2=$1
        fi
        shift
        ;;
      -cid)
        shift
        if test $# -gt 0; then
          export CID=$1
        fi
        shift
        ;;
      -url)
        shift
        if test $# -gt 0; then
          export URL=$1
        fi
        shift
        ;;
      -dat)
        shift
        if test $# -gt 0; then
          export DAT=$1
        fi
        shift
        ;;
      -mtd)
        shift
        if test $# -gt 0; then
          export MTD=$1
        fi
        shift
        ;;
      *)
        printf "\nflag: %s", $1
        break
        ;;
    esac
  done  
  
  printf "\n-oa2: %s, -cid: %s, -url: %s, -dat: %s\n\n" $OA2 $CID $URL $DAT
  
  if [[ -z "${EC_PPS}" ]]; then
    export EC_PPS=$CA_PPRS    
  fi
  
  export EC_PPS=$(agent -hsh -smp)
  TKN=$(agent -gtk -oa2 $OA2 -cid $CID -smp)
  printf "\n bearer token: %s\n\n" $TKN
  agent -ivk -tkn ${TKN} -url ${URL} -dat ${DAT} -mtd ${MTD}
  exit 0
fi

source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/ng-webui/ng.sh)
