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
      *)
        printf "\nflag: %s", "$1"
        break
        ;;
    esac
  done  
  
  printf "\n--cm: %s, --vd: %s, --fq: %s, --ul: %s\n\n" "$EXEC_GIT_COMMIT" "$EXEC_VENDOR" "$EXEC_FREQ" "$EXEC_URL"
  
  TIME=$(date)
  printf "\n\n local time: %s\n\n" "$TIME"
 
  #rm -Rf ~/.ec/script/cli-bootstrap.sh ~/.ec/script/exec-bootstrap.sh
  exec env --ignore-environment /bin/bash -l

  #/bin/bash -l
  #vi
  #exit 0
fi
