#!/bin/bash

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2-`
    echo $PROP_VALUE
}

function setPluginConfig {
    pips=$(getProperty "plg.vln.ips")
    #pcmd=$(getProperty "plg.vln.cmd")
    
    sed -i "s|{EC_IP_ADDR}|$pips|g" ~/.ec/plg/vln/plugins.yml
    #sed -i "s|{EC_VLN_CMD}|$pcmd|g" ~/.ec/plg/vln/plugins.yml
}

echo configure vln plugin
setPluginConfig
#workaround
cp ~/.ec/plg/vln/plugins.yml /root/
