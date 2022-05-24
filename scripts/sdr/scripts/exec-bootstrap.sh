#!/bin/bash

if [[ $# -gt 1 ]]; then

  while test $# -gt 1; do
    case "$1" in
      --cm)
        shift
        if test $# -gt 0; then
          EXEC_GIT_COMMIT="$1"
        fi
        shift
        ;;
      --vd)
        shift
        if test $# -gt 0; then
          EXEC_VENDOR="$1"
        fi
        shift
        ;;
      --fq)
        shift
        if test $# -gt 0; then
          EXEC_FREQ="$1"
        fi
        shift
        ;;
      --ul)
        shift
        if test $# -gt 0; then
          EXEC_URL="$1"
        fi
        shift
        ;;
      --mp)
        shift
        if test $# -gt 0; then
          EXEC_MAP="$1"
        fi
        shift
        ;;
      *)
        printf "\nflag: %s", "$1"
        break
        ;;
    esac
  done  
  
  #printf "\n--cm: %s, --vd: %s, --fq: %s, --ul: %s\n\n" "$EXEC_GIT_COMMIT" "$EXEC_VENDOR" "$EXEC_FREQ" "$EXEC_URL"
  
  #TIME=$(date)
  #printf "\n\n local time: %s\n\n" "$TIME"
 
  #rm -Rf ~/.ec/script/cli-bootstrap.sh ~/.ec/script/exec-bootstrap.sh
  #exec env --ignore-environment /bin/bash -l

  [[ -f ~/.ec/scripts/~exec.sh ]] && rm ~/.ec/scripts/~exec.sh
  GHB_TKN=$(echo "$EXEC_MAP" | jq -r '.GHB_TKN')
  
  if [[ ! -z "$GHB_TKN" ]]; then
    curl -u ":$GHB_TKN" -Ss -o ~/.ec/scripts/~exec.sh "$EXEC_URL"
  else
    wget -q -O ~/.ec/scripts/~exec.sh $EXEC_URL > /dev/null 2>&1
  fi
  
  chmod +x ~/.ec/scripts/~exec.sh
  source ~/.ec/scripts/~exec.sh
  #functional interface to be implemented
  # function name: int_a
  #
  # param1: a base64 string of a custom json object (custom-obj) from script api
  # param2: a base64 string of a custom json object during sac instantiation. format: {\"region1-region1-userpool1\":[\"service1\":\"service2\"],\"region1-region1-userpool2\":[\"service1\":\"service2\"]}
  # 
  # return: stdout. 
  # i.e. printf "%s" "{\"decision\":\"PERMIT\"}";return 0;
  # i.e. printf "%s" "{\"error\":\"error from aws token verification.\"}";return -1;
  int_a "$EXEC_DAT" "$EXEC_MAP"
  exit 0
fi
