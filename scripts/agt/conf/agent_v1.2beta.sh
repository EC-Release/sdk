#!/bin/bash

: '
agent -cfg .ec/conf/${mod}.yml
'
printf "flags %s presented.\n" $@

agent $@
