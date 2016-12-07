#!/bin/bash

#
#  Copyright (c) 2016 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: chia.chang@ge.com
#
set -x
#Loading oracle envs

    export OCI_LIB_DIR=${PWD}/instantclient
    export OCI_INC_DIR=${PWD}/instantclient/sdk/include
    export LD_LIBRARY_PATH=${PWD}/instantclient:$LD_LIBRARY_PATH
    #eval "sed -i -e 's#{OCI_LIB_DIR}#${OCI_LIB_DIR}#g' ./manifest.yml"
    #eval "sed -i -e 's#{OCI_INC_DIR}#${OCI_INC_DIR}#g' ./manifest.yml"
    #eval "sed -i -e 's#{LD_LIBRARY_PATH}#${LD_LIBRARY}#g' ./manifest.yml"

    
    ln -s ${OCI_LIB_DIR}/libclntsh.so.12.1 ./instantclient/libclntsh.so
    ls -al ./instantclient

    echo $OCI_LIB_DIR
    
    #sed -i -e 's/{cfport}/'${PORT}'/g' ./raas-outbound/config/smtp.ini

    #echo "${OCI_LIB_DIR}, ${OCI_INC_DIR}, ${LD_LIBRARY_PATH}"
    
    #export http_proxy=http://proxy-src.research.ge.com:8080
    #export https_proxy"
    npm i oracledb --save-dev &

    node ./server-dummy.js
    
    #ls -la;
#./node_modules/Haraka/bin/haraka -c raas-outbound &
    #sleep 5;
    #./pcs-v1_Darwin
}
