#!/bin/bash

printf "\nexecuting the sed command\n"
sed -i "s/{server-block}/$serverblock/g" ~/.ec/conf/lb/ec-nginx-server-block.conf

printf "\ncat nginx-server-block.conf file\n"
cat ~/.ec/conf/lb/ec-nginx-server-block.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block.conf
