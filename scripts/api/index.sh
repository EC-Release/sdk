#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

mkdir -p ~/.ec/scripts
#wget -q --show-progress -O ~/.ec/scripts/executor.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/executor.sh
wget -q --show-progress -O ~/.ec/scripts/cli.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/cli.sh
wget -q --show-progress -O ~/.ec/scripts/exec.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/exec.sh
#chmod +x ~/.ec/scripts/executor.sh ~/.ec/scripts/exec.sh ~/.ec/scripts/cli.sh
chmod +x ~/.ec/scripts/exec.sh ~/.ec/scripts/cli.sh

ls -la ~/.ec/scripts

if [[ $# -gt 1 ]]; then

  while test $# -gt 1; do
    case "$1" in
      -oa2)
        shift
        if test $# -gt 0; then
          export OA2="$1"
        fi
        shift
        ;;
      -cid)
        shift
        if test $# -gt 0; then
          export CID="$1"
        fi
        shift
        ;;
      -url)
        shift
        if test $# -gt 0; then
          export URL="$1"
        fi
        shift
        ;;
      -dat)
        shift
        if test $# -gt 0; then
          export DAT="$1"
        fi
        shift
        ;;
      -mtd)
        shift
        if test $# -gt 0; then
          export MTD="$1"
        fi
        shift
        ;;
      *)
        printf "\nflag: %s", "$1"
        break
        ;;
    esac
  done  
  
  printf "\n-oa2: %s, -cid: %s, -url: %s, -dat: %s\n\n" "$OA2" "$CID" "$URL" "$DAT"
  
  TIME=$(date)
  printf "\n\n local time: %s\n\n" "$TIME"
  
  if [[ -z "${EC_PPS}" ]]; then
    export EC_PPS=$CA_PPRS    
  fi
  
  export EC_PPS=$(agent -hsh -smp)

  echo agent -gtk -oa2 "$OA2" -cid "$CID" -smp
  
  op=$(agent -gtk -oa2 "$OA2" -cid "$CID" -smp)
  TKN=$(echo "${op##*$'\n'}")
  
  #TKN=$(agent -gtk -oa2 "$OA2" -cid "$CID" -smp | tail -1)
  printf "\n bearer token: %s\n\n" "$TKN"
  agent -ivk -tkn "${TKN}" -url "${URL}" -dat "${DAT}" -mtd "${MTD}"
  exit 0
fi

case $EC_API_APP_NAME in
  ops)
    printf "\n launch webportal 1.x\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/portal1.x/portal.sh)
    ;;
  "dcsc" | "dc")
    printf "\n launch DC Service Cloud Portal 1.x\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/dcsc1.x/portal.sh)
    ;;
  *)
    printf "\n launch EC Engineer Portal 1.x\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/ng-webui/ng.sh)
    ;;
esac

