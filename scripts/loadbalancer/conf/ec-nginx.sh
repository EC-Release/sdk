#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

for(i=0; i<$LBER_REPLICA_COUNT; i++) {
    if my-app-agent-$i = $HOSTNAME
    {
        export CF_INSTANCE_INDEX=$i
    }
}

ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

ls -l /etc/nginx/conf.d

nginx -g 'daemon off;'
