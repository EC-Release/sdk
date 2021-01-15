#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

sed /{server-block}/${server-block} ec-nginx-server-block.conf

nginx -t -c ~/ec-nginx-server-block.conf
