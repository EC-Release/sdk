#!/bin/bash
unset AGENT_REV
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
'

agent "$@"
