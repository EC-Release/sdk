#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

for i in {0..$LBER_REPLICA_COUNT} 
do
    if [ my-app-agent-$i = $HOSTNAME ]
    then
        export CF_INSTANCE_INDEX=$i
    fi
done

application_id=$(uuidgen)
# generate the json string for vcap and export to env
VCAP_APPLICATION="
{
    application_id=$application_id
    application_uris=[$application_uri]
}"
export VCAP_APPLICATION=$VCAP_APPLICATION

ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

ls -l /etc/nginx/conf.d

nginx -g 'daemon off;'
