#!/bin/bash

: '
agent -cfg .ec/conf/${mod}.yml
'

printf "\nfile %s executed.\n" $@
agent $@
