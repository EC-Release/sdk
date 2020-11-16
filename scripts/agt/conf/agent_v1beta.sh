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

if [[ $# -nq 0 ]]; then
    agent $@
    exit 0
fi

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

if [[ $plg == *true* || $plg == true ]] && [[ $mod == "server" || $mod == "gw:server" ]]; then
  case $ptp in
    tls)
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
      sed -i "s|{EC_VLN}|true|g" ~/.ec/conf/${mod}.yml
      sed -i "s|{EC_RPT}|$rpt|g" ~/.ec/conf/${mod}.yml

      plg=true
      echo "deploying vln plugin"
      source ~/.ec/plg/vln/vln.sh
      ;;
    *)
      sed -i "s|{EC_VLN}|false|g" ~/.ec/conf/${mod}.yml
      sed -i "s|{EC_RPT}|0|g" ~/.ec/conf/${mod}.yml
      echo "no plugin type specified"
      ;;
  esac
else
  plg=false    
  sed -i "s|{EC_VLN}|false|g" ~/.ec/conf/${mod}.yml
fi

sed -i "s|{EC_AID}|$aid|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_TID}|$tid|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_CID}|$cid|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_CSC}|$csc|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_OA2}|$oa2|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_DUR}|$dur|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_DBG}|$dbg|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_ZON}|$zon|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_GRP}|$grp|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_CPS}|$cps|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_LPT}|$lpt|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_GPT}|$gpt|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_RPT}|$rpt|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_RHT}|$rht|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_HST}|$hst|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_SST}|$sst|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_TKN}|$tkn|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_PXY}|$pxy|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_PLG}|$plg|g" ~/.ec/conf/${mod}.yml
sed -i "s|{EC_HCA}|$hca|g" ~/.ec/conf/${mod}.yml


cat ~/.ec/conf/${mod}.yml
agent -cfg .ec/conf/${mod}.yml
