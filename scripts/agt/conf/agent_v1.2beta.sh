#!/bin/bash

: '
agent -cfg .ec/conf/${mod}.yml
'

printf "\nflags %s presented.\n" $@
agent $@
