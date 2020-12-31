#!/bin/bash

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2-`
    PROP_VALUE=$(echo $PROP_VALUE | sed 's|\"||g')
    echo $PROP_VALUE
}

function setPluginConfig {
    pscm=$(getProperty "plg.tls.scm")
    phst=$(getProperty "plg.tls.hst")
    pspt=$(getProperty "plg.tls.prt")
    ppxy=$(getProperty "plg.tls.pxy")
    plpt=$(getProperty "plg.tls.lpt")
    #pcmd=$(getProperty "plg.tls.cmd")
    
    sed -i "s|{EC_TLS_SCHEMA}|$pscm|g" ~/.ec/plg/tls/plugins.yml
    sed -i "s|{EC_TLS_HOSTNAME}|$phst|g" ~/.ec/plg/tls/plugins.yml
    sed -i "s|{EC_TLS_PORT}|$pspt|g" ~/.ec/plg/tls/plugins.yml
    sed -i "s|{EC_TLS_PXY}|$ppxy|g" ~/.ec/plg/tls/plugins.yml
    sed -i "s|{EC_TLS_RPT}|$plpt|g" ~/.ec/plg/tls/plugins.yml
    #sed -i "s|{EC_TLS_CMD}|$pcmd|g" ~/.ec/plg/tls/plugins.yml
}
echo configure vls plugin
setPluginConfig
cat ~/.ec/plg/tls/plugins.yml
#workaround
cp ~/.ec/plg/tls/plugins.yml /root/
