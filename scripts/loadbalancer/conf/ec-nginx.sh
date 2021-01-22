#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

printf "\nnginx-server-block.conf file.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block.conf

printf "\nexecuting the sed command..............\n"
ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ec-nginx-server-block.conf > ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block-updated.conf
