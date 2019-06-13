#!/bin/bash

if [[ -z $DYNAMOTABLE ]];then
        DYNAMOTABLE=$(aws dynamodb list-tables | jq -r '.[][]|select( (.| contains ("'$PREFIX'")) and (.|contains("DYNAMOTABLE")))')
fi
echo "dynamodb-table=$DYNAMOTABLE"
ami=$(jq -r '.builds[0].artifact_id' manifest.json)
aws dynamodb update-item \
  --table-name $DYNAMOTABLE \
  --key '{ "id": { "S": "'$CODEBUILD_BUILD_ID'" }}' \
  --expression-attribute-names '{"#ami": "ami"}' \
  --expression-attribute-values '{":ami_value":{"S": "'$ami'"}}' \
  --update-expression "SET #ami = :ami_value"
