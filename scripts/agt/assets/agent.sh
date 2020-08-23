#!/bin/sh
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
    echo $PROP_VALUE
}

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

#plugin type. e.g. tls, vln, etc.
ptp=$(getProperty "plg.typ")

if [[ $pxy == *false* ]] || [[ $pxy == false ]]; then
  pxy=""
else
  pxy="pxy: ${pxy}"
fi


if [[ $plg == *true* ] || [ $plg == true ]] && [[ $mod == "server" ] || [ $mod == "gw:server" ]]; then
  case $ptp in
    tls)
      echo "deploying tls plugin"
      source ~/.ec/plg/tls/tls.sh
      break;
      ;;
    *)
      echo "no plugin type specified"
      ;;
  esac
fi

if [[ $plg == *true* ] || [ $plg == true ]] && [[ $mod == "client" ] || [ $mod == "gw:client" ]]; then
  case $ptp in
    vln)
      echo "deploying vln plugin"
      source ~/.ec/plg/vln/vln.sh
      break
      ;;
    *)
      echo "no plugin type specified"
      ;;
  esac
fi

sed -i "s|{EC_AID}|$aid|g" ~/${mod}.yml
sed -i "s|{EC_TID}|$tid|g" ~/${mod}.yml
sed -i "s|{EC_CID}|$cid|g" ~/${mod}.yml
sed -i "s|{EC_CSC}|$csc|g" ~/${mod}.yml
sed -i "s|{EC_OA2}|$oa2|g" ~/${mod}.yml
sed -i "s|{EC_DUR}|$dur|g" ~/${mod}.yml
sed -i "s|{EC_DBG}|$dbg|g" ~/${mod}.yml
sed -i "s|{EC_ZON}|$zon|g" ~/${mod}.yml
sed -i "s|{EC_GRP}|$grp|g" ~/${mod}.yml
sed -i "s|{EC_CPS}|$cps|g" ~/${mod}.yml
sed -i "s|{EC_LPT}|$lpt|g" ~/${mod}.yml
sed -i "s|{EC_GPT}|$gpt|g" ~/${mod}.yml
sed -i "s|{EC_RPT}|$rpt|g" ~/${mod}.yml
sed -i "s|{EC_RHT}|$rht|g" ~/${mod}.yml
sed -i "s|{EC_HST}|$hst|g" ~/${mod}.yml
sed -i "s|{EC_SST}|$sst|g" ~/${mod}.yml
sed -i "s|{EC_TKN}|$tkn|g" ~/${mod}.yml
sed -i "s|{EC_PXY}|$pxy|g" ~/${mod}.yml
sed -i "s|{EC_PLG}|$plg|g" ~/${mod}.yml
sed -i "s|{EC_HCA}|$hca|g" ~/${mod}.yml

cat ./${mod}.yml
agent -cfg ./${mod}.yml
