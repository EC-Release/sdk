#!/bin/bash
#
#  Copyright (c) 2020 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2-`
    PROP_VALUE=$(echo $PROP_VALUE | sed 's|\"||g')
    echo $PROP_VALUE
}

if [[ $# -ne 0 ]]; then
    agt "$@"
    return 0
fi

wget -q -O "$HOME/.ec/agt/conf/client.yml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/conf/client.yml
wget -q -O "$HOME/.ec/agt/conf/gateway.yml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/conf/gateway.yml
wget -q -O "$HOME/.ec/agt/conf/server.yml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/conf/server.yml
wget -q -O "$HOME/.ec/agt/conf/gw:client.yml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/conf/gw:client.yml
wget -q -O "$HOME/.ec/agt/conf/gw:server.yml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/conf/gw:server.yml

#converting the env vars to simple params
mod=$(getProperty "conf.mod")
aid=$(getProperty "conf.aid")
tid=$(getProperty "conf.tid")
cid=$(getProperty "conf.cid")
csc=$(getProperty "conf.csc")
oa2=$(getProperty "conf.oa2")
dur=$(getProperty "conf.dur")
dbg=$(getProperty "conf.dbg")
zon=$(getProperty "conf.zon")
grp=$(getProperty "conf.grp")
cps=$(getProperty "conf.cps")
lpt=$(getProperty "conf.lpt")
gpt=$(getProperty "conf.gpt")
rpt=$(getProperty "conf.rpt")
rht=$(getProperty "conf.rht")
hst=$(getProperty "conf.hst")
sst=$(getProperty "conf.sst")
tkn=$(getProperty "conf.tkn")
pxy=$(getProperty "conf.pxy")
plg=$(getProperty "conf.plg")
hca=$(getProperty "conf.hca")
sts=$(getProperty "conf.sts")
vln=$(getProperty "conf.vln")
rpt=$(getProperty "conf.rpt")

#plugin type. e.g. tls, vln, etc.
ptp=$(getProperty "plg.typ")

if [[ $pxy == *false* || $pxy == false || -z "$pxy" ]]; then
  pxy=""
else
  pxy=$($pxy | tr -cd "[:alnum:]\:\/\.")
  pxy="pxy: \"${pxy}\""
fi

if [ -z "$sts" ]; then
  sts=""
else
  sts="sts: \"${sts}\""
fi

if [[ $plg == *true* || $plg == true ]] && [[ $mod == "server" || $mod == "gw:server" ]]; then
  case $ptp in
    tls)
      source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/plg/tls/v1.linux64.txt)
      
      #force plg setting
      plg=true
    
      echo "deploying tls plugin"
      source ~/.ec/plg/tls/tls.sh
      ;;
    *)
      echo "no plugin type specified"
      ;;
  esac
elif [[ $plg == *true* || $plg == true ]] && [[ $mod == "client" || $mod == "gw:client" ]]; then
  case $ptp in
    vln)

      sed -i "s|{EC_VLN}|true|g" ~/.ec/agt/conf/${mod}.yml
      sed -i "s|{EC_RPT}|$rpt|g" ~/.ec/agt/conf/${mod}.yml

      source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/plg/vln/v1.linux64.txt)

      plg=true
      echo "deploying vln plugin"
      source ~/.ec/plg/vln/vln.sh
      ;;
    *)
      sed -i "s|{EC_VLN}|false|g" ~/.ec/agt/conf/${mod}.yml
      sed -i "s|{EC_RPT}|0|g" ~/.ec/agt/conf/${mod}.yml
      echo "no plugin type specified"
      ;;
  esac
else
  plg=false    
  sed -i "s|{EC_VLN}|false|g" ~/.ec/agt/conf/${mod}.yml
fi

if [[ -v IS_EKS_ENV && $IS_EKS_ENV == "true" ]]; then
  export CF_INSTANCE_INDEX=${HOSTNAME##*-}
  
  export VCAP_APPLICATION="{
  \"application_id\": \"${uuid}\",
  \"application_uris\": [\"${EC_HOSTNAME}\"]
}"

  printf "\n************ Hostname: %s\n" "${HOSTNAME##*-}"
  printf "\n************ Refernce id: %s\n" "$CF_INSTANCE_INDEX"
  printf "\n************ VCAP_APPLICATION: %s\n" "$VCAP_APPLICATION"
fi

sed -i "s|{EC_AID}|$aid|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_TID}|$tid|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_CID}|$cid|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_CSC}|$csc|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_OA2}|$oa2|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_DUR}|$dur|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_DBG}|$dbg|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_ZON}|$zon|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_GRP}|$grp|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_CPS}|$cps|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_LPT}|$lpt|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_GPT}|$gpt|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_RPT}|$rpt|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_RHT}|$rht|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_HST}|$hst|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_SST}|$sst|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_TKN}|$tkn|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_PXY}|$pxy|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_PLG}|$plg|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_HCA}|$hca|g" ~/.ec/agt/conf/${mod}.yml
sed -i "s|{EC_STS}|$sts|g" ~/.ec/agt/conf/${mod}.yml


cat ~/.ec/agt/conf/${mod}.yml
agt -cfg .ec/agt/conf/${mod}.yml
