  
#!/bin/bash

function clone_push(){
    mkdir -p push
    wget -q --show-progress -O ./manifest.yml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/push/manifest.yml
    login
    echo "Login successful"
    #cp ./manifest.yml ./push/manifest.yml
    # 9/11/2021
    #
    while read line; do
      ZONE=$line
      echo "Updating $ZONE.."
      
      {
        getEnvs
        echo "Fetched ENVs"      
      } || {
        echo "failed fetched envs for ${ZONE}. proceed to next instance"
        echo "${ZONE}" > ./err_ins.txt
        
        continue
      }
      
      op=$(cat values.txt | grep UPDATED | cut -d ' ' -f2)
      if [[ "$op" == *"$MISSION"* ]]; then
        echo "instance $ZONE has been marked as updated.　proceed to next instance"
        continue
      fi
      
      cp ./manifest.yml ./push/manifest.yml
      
      #cat ./push/manifest.yml
      {
        setEnvs      
        echo "Manifest file updated"    
      } || {
        echo "failed update the manifest file. proceed to next instance"
        echo "${ZONE}" > ./err_ins.txt
        continue
      }
      
      cat ./push/manifest.yml
      
      cd ./push
      {
        updateService | tee output.txt
        if grep -q FAILED output.txt; then
          echo "Service update unsuccessful. proceed to next instance"
          echo "${ZONE}" > ./../err_ins.txt
        else
          cf set-env ${ZONE} UPDATED '2022'
          echo "Service updated successful"
        fi        
      } || {
        echo "Service update unsuccessful. proceed to next instance"
      }
      cd -
    done < service_list.txt
    echo "update completed."    
         
    {
      echo "instance list failed during the update.."
      cat err_ins.txt      
    }
}
