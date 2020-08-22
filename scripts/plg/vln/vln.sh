#!/bin/sh

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2-`
    echo $PROP_VALUE
}

function setPluginConfig {
    pips=$(getProperty "plg.vln.ips")
    pstt=$(getProperty "plg.vln.stt")
    
    sed -i "s|{EC_IP_ADDR}|$pips|g" ~/.ec/plg/vln/plugins.yml
    sed -i "s|{EC_STATUS}|$pstt|g" ~/.ec/plg/vln/plugins.yml
}

setPluginConfig
cp ~/.ec/plg/vln/plugins.yml ~/
