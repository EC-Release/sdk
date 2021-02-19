#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

# refer serverblock to https://github.com/EC-Release/oci/blob/fd2ad16359a79f0436654d3e9a56fc327ed709db/k8s/agent%2Bhelper/templates/_loadbalancer.tpl
# env var params: @@stsName @@Namespace @@replicaCount
# output: @@upstreamApp @@upstreamMaster @@nginxMap
### begin of nginx config
set @@upstreamApp=''
for int i;i++;i<@@replicaCount {
    @@upstreamApp=@@upstreamApp +
      `upstream app{{ @i }} {
        server {{ @@stsName }}-{{ @i }}.{{ @@stsName }}.{{ @@Namespace }}.svc.cluster.local:7990;
      }`
}

set @@upstreamMaster='upstream master {'
for int i;i++;i<@@replicaCount {
    @@_upstreamMaster=@@_upstreamMaster + 
      `server @@stsName-@i.@@stsName.@Namespace.svc.cluster.local:7990;`
}
@@upstreamMaster=@@upstreamMaster+@@_upstreamMaster+'}'

set @@nginxMap='map $http_X_CF_APP_INSTANCE $pool {
  default "master";'
for int i;i++;i<@@replicaCount {
    @@_nginxMap=@@_nginxMap + `
      
    `
}

set ESCAPED=@@upstreamApp+'\n '+@@upstreamMaster+'\n'+@@nginxMap
### end of nginx config

# depricated
#ESCAPED=$(echo "${serverblock}" | sed '$!s@$@\\@g')

sed "s/UPSTREAMBLOCK/${ESCAPED}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf
cp -f ~/.ec/conf/lb/nginx.conf /etc/nginx/nginx.conf

nginx -g 'daemon off;'
