#!/bin/bash

printf "\nexecuting the sed command..............\n"
sed -i "s/UPSTREAMBLOCK/$serverblock/g" ~/.ec/conf/lb/ec-nginx-server-block.conf
printf "\n serverblock env value: $serverblock\n"

printf "\nnginx-server-block.conf file.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block.conf
