#!/bin/bash
export AGENT_REV=
: '
agent -cfg .ec/conf/${mod}.yml
printf "flag %s presented.\n" "$@"
'

agent "$@"
