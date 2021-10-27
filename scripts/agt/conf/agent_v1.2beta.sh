#!/bin/bash
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
export EC_PPS=$CA_PPRS
[[ ! -z "${EC_PPS}" ]] && echo "Not empty" || echo "Empty"
'

#function outputYaml {
#    PROP_KEY=$1
#    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2-`
#    echo $PROP_VALUE
#}

if [[ ! -z "${EC_PPS}" ]]; then
  export EC_PPS=$(agent -hsh -smp)
fi

if [[ ! -z "${PORT}" ]]; then
  export EC_GPT=:$PORT
fi

if [[ $* == *-cvt* ]]; then
  touch /tmp/out.yaml          
  while test $# -gt 1; do
    case "$1" in
      -cvt)
        printf "\nflag cvt detected\n"
        shift
        ;;
      -mod)
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.mod' "$1"
        fi
        shift
        ;;
      -aid)
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.aid' "$1"
        fi
        shift
        ;;
      -oa2)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.oa2' "$1"
        fi
        shift
        ;;
      -cid)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.cid' "$1"
        fi
        shift
        ;;
      -csc)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.csc' "$1"
        fi
        shift
        ;;
      -hst)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.hst' "$1"
        fi
        shift
        ;;
      -rpt)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.rpt' "$1"
        fi
        shift
        ;;
      -rht)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.rht' "$1"
        fi
        shift
        ;;
      -grp)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.grp' "$1"
        fi
        shift
        ;;
      -zon)      
        shift
        if test $# -gt 0; then
          yq w -i /tmp/out.yaml 'ec-config.conf.zon' "$1"
        fi
        shift
        ;;
      *)
        printf "\nflag: %s\n", "$1"
        break
        ;;
    esac
  done
  
  agent -enc -fil /tmp/out.yaml 
  exit 0
fi

if [[ ! -z "${EC_SED}" ]]; then
  printenv
  cat ~/.ec/agt/conf/x:gateway.yml
  agent -cfg ./.ec/agt/conf/x:gateway.yml
  exit 0
fi

if [[ ! -z "${EC_RHT}" ]]; then
  printenv
  cat ~/.ec/agt/conf/x:server.yml
  agent -cfg ./.ec/agt/conf/x:server.yml
  exit 0
fi

agent "$@"
