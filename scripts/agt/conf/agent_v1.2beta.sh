#!/bin/bash
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
export EC_PPS=$CA_PPRS
[[ ! -z "${EC_PPS}" ]] && echo "Not empty" || echo "Empty"
'

if [[ ! -z "${EC_PPS}" ]]; then
  export EC_PPS=$(agent -hsh -smp)
fi  
  
agent "$@"
