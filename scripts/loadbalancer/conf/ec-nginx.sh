#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

sed -i "s/{server-block}/$serverblock/g" ~/.ec/conf/lb/ec-nginx-server-block.conf

# 0 to 10 (replicaCount)
for(i=0; i<replicaCount; i++) {
    if my-app-agent-$i = $HOSTNAME
    {
        export CF_INSTANCE_INDEX=$i
    }
}


nginx -t -c ~/.ec/conf/lb/ec-nginx-server-block.conf
