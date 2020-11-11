#!/bin/bash

: '
agent -cfg .ec/conf/${mod}.yml
'

printf "file %s executed." $0
agent $@

