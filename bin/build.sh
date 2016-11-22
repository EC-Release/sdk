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

#set -x
set -e

function docker_run () {
    export https_proxy=${PROXY}
    #docker pull golang
    docker build -t ${ARTIFACT}_img .
    docker run -i --name ${ARTIFACT}_inst ${ARTIFACT}_img

    CID=$(docker ps -aqf "name=${ARTIFACT}_inst")
    IID=$(docker images -q ${ARTIFACT}_img)

    git clone https://d5bf6412b40c3ac87c557999df7e95a090974fb4@github.com/Enterprise-connect/ec-sdk.git ./${DIST}/
    
    docker cp ${CID}:/${DIST}/. ./${DIST}/bin/

    docker rm ${CID}

    docker rmi ${IID}
}

function jenkins_checkin (){
    
    #cp ./README.md ./${DIST}/README_${ARTIFACT}.md
    #cd ./${DIST}
    #op=$(git status --porcelain)

    git add . &> /dev/null
    if [ $? -eq 0 ] ; then

	git commit -m "EC Build#${BUILD_VER} check-in."  &> /dev/null

	if [ $? -eq 0 ] ; then
	    echo "The changes has been pushed.";
	else
	    echo "catch"
	    exit 0
	    
	fi;
        #git push origin master 

	
    else 
	echo "No changes are detected"; 
	exit 0; 
    fi;
}

function readinputs () {

    if [ $# -eq 0 ]
    then
	printf "   %-*s\n" 10 "-p    | proxy"
	printf "   %-*s\n" 10 "-r    | revision"
	printf "   %-*s\n" 10 "-b    | build version by Jenkins"
	
	printf "   %-*s\n" 10 "-e    | environemntal variables"
	printf "   %-*s\n" 10 "-user | cf username"
	printf "   %-*s\n" 10 "-pwd  | cf password"
	printf "   %-*s\n" 10 "-end  | cf endpoint"
	printf "   %-*s\n" 10 "-org  | cf org"
	printf "   %-*s\n" 10 "-spc  | cf space"
	printf "   %-*s\n" 10 "-sql  | postgresSql constr"
	printf "   %-*s\n" 10 "-husr | haraka user"
	printf "   %-*s\n" 10 "-hpwd | haraka pwd"
	printf "   %-*s\n" 10 "-hhst | haraka host"
	printf "   %-*s\n" 10 "-hsht | haraka smtp host"
	printf "   %-*s\n" 10 "-tpwd | temp pwd. idea Led by the PCS team, not Chia."
    else
	for ((i = 1; i <=$#; i++));
	do
	    case ${@:i:1} in
		-p)
		    PROXY=${@:i+1:1}
		    ;;
		-r)
		    REV=${@:i+1:1}
		    ;;
		
		-e)
		    ENV=${@:i+1:1}
		    ;;
		-b)
		    BUILD_VER=${@:i+1:1}
		    ;;
		-user)
		    CF_USER=${@:i+1:1}
		    ;;
		-pwd)
		    CF_PWD=${@:i+1:1}		   
		    ;;
		-end)
		    CF_END=${@:i+1:1}		   
		    ;;
		-org)
		    CF_ORG=${@:i+1:1}		   
		    ;;
		-spc)
		    CF_SPC=${@:i+1:1}		   
		    ;;
		-sql)
		    SQLDSN=${@:i+1:1}
		    ;;
		-husr)
		    HUSER=${@:i+1:1}
		    ;;
		-hpwd)
		    HPWD=${@:i+1:1}
		    ;;
		-hhst)
		    HHOST=${@:i+1:1}
		    ;;
		-hsht)
		    HSHOST=${@:i+1:1}
		    ;;
		-tpwd)
		    TEMPPWD=${@:i+1:1}
		    ;;
		*)
		    #echo "Invalid option ${@:i:1}"
	            ;;
	    esac
	done
    fi

}


#no_docker_run
#docker_run
jenkins_checkin
#cf_push
