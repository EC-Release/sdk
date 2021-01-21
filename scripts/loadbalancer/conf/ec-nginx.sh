#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

sed -i "s/{server-block}/$serverblock/g" ~/.ec/conf/lb/ec-nginx-server-block.conf

nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block.conf
