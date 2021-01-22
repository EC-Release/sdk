#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

printf "\nnginx-server-block.conf file.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block.conf

upstreamblock=`echo ${serverblock} | tr '\n' "\\n"`
printf "\nupstreamblock: $upstreamblock\n"

printf "\nexecuting the sed command..............\n"
sed -i "s/UPSTREAMBLOCK/$upstreamblock/g" ~/.ec/conf/lb/ec-nginx-server-block.conf

printf "\nnginx-server-block.conf file after sed.........\n"
cat ~/.ec/conf/lb/ec-nginx-server-block.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block.conf
