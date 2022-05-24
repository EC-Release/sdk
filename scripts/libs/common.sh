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

type -P python3 >/dev/null 2>&1 || \
cat << EOF
-------------------------------------
[*] warning: python3 is unavailable
-------------------------------------
EOF

{
    agt -ver &> /dev/null
} || {
      
    echo " |_ installing system utilities.."
    if [[ $AGENT_REV == "1.2-rc"* ]]; then
      source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2.linux64.txt) -ver
    else
      #echo 1.2-b
      source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64.txt) -ver
    fi
}

echo "  |_ importing common libraries & tools.."

# $1: string to be trimed
function trimStr () {
  echo $1 | tr -d '[:space:]'
}

function getRandomStr () {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 20 ; echo ''
}

#check if the string $1 is a UUID
function isUUID () {

  if [[ $1 =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
      printf "0"
  else
      printf "1"
  fi

}

#check if the string $1 contains a UUID
function findUUID () {
  echo $1 | grep -Po '[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}'
}

function parse_yaml () {
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
      -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
  }'
}

export URI_REGEX='^(([^:/?#]+):)?(//((([^:/?#]+)@)?([^:/?#]+)(:([0-9]+))?))?(/([^?#]*))(\?([^#]*))?(#(.*))?'

function parse_scheme () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[2]}"
}

function parse_authority () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[4]}"
}

function parse_user () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[6]}"
}

function parse_host () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[7]}"
}

function parse_port () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[9]}"
}

function parse_path () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[10]}"
}

function parse_rpath () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[11]}"
}

function parse_query () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[13]}"
}

function parse_fragment () {
    [[ "$@" =~ $URI_REGEX ]] && echo "${BASH_REMATCH[15]}"
}

# $1: url string
function getURLPort () {
  #ph=$(parse_host $1)
  #pt=$(parse_port $1)
  #printf "%s:%s" "$ph" "$pt"
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.port:
  print('', end='')
else:
  print(r.port, end='')
END
}

# $1: url string
function getURLHostname () {
  #ph=$(parse_host $1)
  #pt=$(parse_port $1)
  #printf "%s:%s" "$ph" "$pt"
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.hostname:
  print('', end='')
else:
  print(r.hostname, end='')
END
}

# $1: url string
function getURLHostnameAndPort () {
  #ph=$(getURLHostname $1)
  #pt=$(getURLPort $1)
  #printf "%s:%s" "$ph" "$pt"  
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.netloc:
  print('', end='')
else:
  print(r.netloc, end='')
END
}

# $1: url string
function getURLHostnameAndPortAndScheme () {
  #ph=$(getURLHostname $1)
  #pt=$(getURLPort $1)
  #printf "%s:%s" "$ph" "$pt"  
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.netloc:
  print('', end='')
else:
  print ("%s://%s" % (r.scheme, r.netloc), end='')
END
}

# $1: url string
function getURLScheme () {
  #parse_scheme $1
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.scheme:
  print('', end='')
else:
  print(r.scheme, end='')
END
}

# $1: url string
function getURLPath () {
  #parse_path $1
  python3 - "$1" <<END
import sys,os
from urllib.parse import urlparse
r = urlparse(sys.argv[1])
if not r.path:
  print('', end='')
else:
  print(r.path, end='')
END
}

# $1: host; $2: port
function tcpHealthCheck () {
  python3 - "$1" "$2" <<END
import sys,socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(2)                                  
r = sock.connect_ex((sys.argv[1],int(sys.argv[2])))
if r == 0:
  print('OK',end='')
else:
  print('CLOSED: '+str(r))
END
}
