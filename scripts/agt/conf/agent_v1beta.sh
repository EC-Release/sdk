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
    nohup agent "$@" &

    timer=0
    while true
    do
      sleep 5
      curl -s -o /dev/null -w "%{http_code}" http://localhost:27991/status
      echo ""

      timer=$((timer+1))

      if [ $timer -eq ${TIME_INTERVAL} ]
      then
        reporttime=`date '+%Y%m%d%H%M%S'`
        PORTAL_URL_UPDATED="${PORTAL_URL}_${reporttime}"

        searchstr="hca"
        process=`ps -ef | grep agent | grep hca`
        temp=${process#*$searchstr}
        hca=`echo $temp | awk '{print $1}'`

        healthresult=`curl localhost:${hca}/health`
        healthresultupdated=`echo ${healthresult} | sed 's/"//g'`

        data="{\"parent\":\"${PARENT_NODE}\",\"data\":\"${healthresultupdated}\"}"
        ~/.ec/agt/bin/tengu_linux_sys -ivk -tkn "${TKN}" -url "${PORTAL_URL_UPDATED}" -dat $data -mtd POST
        timer=0
        echo "------------------------------------------------------------"
      fi
    done

    return 0
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
      sed -i "s|{EC_VLN}|true|g" ~/.ec/agt/conf/${mod}.yml
      sed -i "s|{EC_RPT}|$rpt|g" ~/.ec/agt/conf/${mod}.yml

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


cat ~/.ec/agt/conf/${mod}.yml

agent -cfg .ec/agt/conf/${mod}.yml