#!/bin/bash

PACKER_TMP=$(cat packer_template.json)


if [[ -n "$AMI_USERS" ]]
then  
  PACKER_TMP=$(echo $PACKER_TMP | jq --argjson foo $(echo -n "${AMI_USERS/%,/}" | jq -R -r -c 'split(",")') '.builders[0].ami_users |=.+$foo')  
  #echo $PACKER_TMP | jq . 
fi

if [[ -n "$AMI_REGIONS" ]] 
then 
  PACKER_TMP=$(echo $PACKER_TMP | jq --argjson foo $(echo -n "${AMI_REGIONS/%,/}" | jq -R -r -c 'split(",")') '.builders[0].ami_regions |=.+$foo')
  #echo $PACKER_TMP | jq . 
fi

if [[ "$PLATFORM" =~ "ubuntu" ]] 
then 
  PACKER_TMP=$(echo $PACKER_TMP | jq '.provisioners[0].extra_arguments |= .+["ansible_python_interpreter=/usr/bin/python3"]')
  #echo $PACKER_TMP | jq . 
fi
  
  
echo $PACKER_TMP | jq .
  
  
echo $PACKER_TMP | USER=${SSH_USERNAME} \
packer build \
-color=false \
-parallel=true \
-
