#!/bin/bash

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

if [[ -z $namespace ]]; then
  printf "\n\n*************** not a k8s environment. exiting the process.\n"
  exit 0
fi

# refer serverblock to https://github.com/EC-Release/oci/blob/fd2ad16359a79f0436654d3e9a56fc327ed709db/k8s/agent%2Bhelper/templates/_loadbalancer.tpl
# env var params: @@stsName @@namespace @@replicaCount @@uuid
# output: @@TheNginxConf
### begin of nginx config
function getNginxConf {
    stsName=$1
    namespace=$2
    replicaCount=$3
    uuid=$4
    
    upstreamApp=""
    for ((i = 0; i < ${replicaCount}; i++)); do
      upstreamApp+="upstream app-${i} {
      server ${stsName}-${i}.${stsName}.${namespace}.svc.cluster.local:7990;
    }
    "
    done

    upstreamMaster="upstream master {"
    _upstreamMaster=""
    for ((i = 0; i < ${replicaCount}; i++)); do
      _upstreamMaster+="  server ${stsName}-${i}.${stsName}.${namespace}.svc.cluster.local:7990;
    "
    done
    upstreamMaster="${upstreamMaster}${_upstreamMaster}}"

    nginxMap='map $http_X_CF_APP_INSTANCE $pool {
      default "master";
    '
    for ((i = 0; i < ${replicaCount}; i++)); do
      _nginxMap+="  ${uuid}:${i} app-${i};
    "  
    done
    nginxMap="${nginxMap}${_nginxMap}}"

    printf "%s\n%s\n%s" "$upstreamApp" "$upstreamMaster" "$nginxMap"
}

### end of nginx config

ESCAPED=$(getNginxConf "${stsName}" "${namespace}" "${replicaCount}" "${uuid}")

ESCAPED1=$(echo "${ESCAPED}" | sed '$!s@$@\\@g')

sed "s/UPSTREAMBLOCK/${ESCAPED1}/g" ~/.ec/conf/lb/ec-nginx-server-block.conf > ~/.ec/conf/lb/ec-nginx-server-block-updated.conf

cp -f ~/.ec/conf/lb/nginx.conf /etc/nginx/nginx.conf
cp ~/.ec/conf/lb/ec-nginx-server-block-updated.conf /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

printf "\n\n*************** ec-nginx-server-block-updated.conf: \n\n"
cat /etc/nginx/conf.d/ec-nginx-server-block-updated.conf

if [[ -v namespace && $namespace == "test" ]]; then
  printf "\n\n*************** CI environment to test the spec.\n"
  exit 0
fi

nginx -g 'daemon off;'
