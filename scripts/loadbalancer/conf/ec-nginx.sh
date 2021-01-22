#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block-updated.conf
