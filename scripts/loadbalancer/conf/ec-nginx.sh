#!/bin/bash

printf "\n serverblock env value: $serverblock\n"

for i in {0..$AGENT_REPLICA_COUNT} 
do
    if [ my-app-agent-$i = $HOSTNAME ]
    then
        export CF_INSTANCE_INDEX=$i
    fi
done

application_uri=$APPLICATION_URI
# generate the json string for vcap and export to env
vcap_application="
{
    application_id=$APPLICATION_ID
    application_uris=[$application_uri[host]]
}"
export VCAP_APPLICATION=$vcap_application

ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')
sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

printf "\nnginx-server-block-updated.conf file after sed.........\n"
cat /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

ls -l /etc/nginx/conf.d
echo "VCAP_APPLICATION: " $VCAP_APPLICATION
echo "CF_INSTANCE_INDEX: " $CF_INSTANCE_INDEX

nginx -g 'daemon off;'
