#!/bin/bash
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
'
  
if [[ -z "${EC_PPS}" ]]; then
  export EC_PPS=$CA_PPRS    
fi  
  
export EC_PPS=$(agent -hsh -smp)

agent "$@"
