#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

ls -l /etc/nginx/conf.d

while sleep 3600; do :; done
