#!/bin/bash
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
'
printf "system date: %s" "$(date)"

agent "$@"
