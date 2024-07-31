#!/bin/bash

set -Eeuo pipefail

# Fail fast the deployment if envs are empty
if [[ -z "$SUBSCRIPTION_ID" ]]; then
  echo "The subscription Id is not successfully retrieved, please retry another deployment." >&2
  exit 1
fi

if [[ -z "$RESOURCE_GROUP" ]]; then
  echo "The resource group is not successfully retrieved, please retry another deployment." >&2
  exit 1
fi

if [[ -z "$ASA_SERVICE_NAME" ]]; then
  echo "The Azure Spring Apps service name is not successfully retrieved, please retry another deployment." >&2
  exit 1
fi

echo SUBSCRIPTION_ID is $SUBSCRIPTION_ID >> $AZ_SCRIPTS_OUTPUT_PATH
echo RESOURCE_GROUP is $RESOURCE_GROUP >> $AZ_SCRIPTS_OUTPUT_PATH
echo ASA_SERVICE_NAME is $ASA_SERVICE_NAME >> $AZ_SCRIPTS_OUTPUT_PATH
echo MY_APP_NAME is $MY_APP_NAME >> $AZ_SCRIPTS_OUTPUT_PATH
echo AZURE_KEYVAULT_ENABLED is $AZURE_KEYVAULT_ENABLED >> $AZ_SCRIPTS_OUTPUT_PATH
echo AZURE_KEYVAULT_URI is $AZURE_KEYVAULT_URI >> $AZ_SCRIPTS_OUTPUT_PATH

get_resource_upload_url_result=$(az rest -m post -u "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.AppPlatform/Spring/$ASA_SERVICE_NAME/apps/$MY_APP_NAME/getResourceUploadUrl?api-version=2023-05-01-preview")
upload_url=$(echo $get_resource_upload_url_result | jq -r '.uploadUrl')
relative_path=$(echo $get_resource_upload_url_result | jq -r '.relativePath')
source_url="https://github.com/Azure/spring-cloud-azure-tools/releases/download/0.0.1/hello-world-0.0.1.jar"
auth_header="no-auth"

storage_account_name=$(echo $upload_url | awk -F'[/.]' '{print $3}')
storage_endpoint=$(echo $upload_url | awk -F'/' '{print "https://" $3}')
share_name=$(echo $upload_url | awk -F'/' '{print $4}')
folder=$(echo $upload_url | awk -F'?' '{print $1}' | awk -F'/' '{for(i=5;i<NF-1;i++) printf "%s/",$i; print $(NF-1)}')
path=$(echo $upload_url | awk -F'[/?]' '{print $(NF-1)}')
sas_token=$(echo $upload_url | awk -F'?' '{print $2}')

# Download binary
echo "Downloading binary from $source_url to $path"
if [ "$auth_header" == "no-auth" ]; then
    curl -L "$source_url" -o $path
else
    curl -H "Authorization: $auth_header" "$source_url" -o $path
fi

# Upload to remote
echo "Upload '$source_url' to '$storage_account_name' at '$storage_endpoint/$share_name/$folder/$path'"

echo "az storage file upload -s $share_name --source $path --account-name  $storage_account_name --file-endpoint $storage_endpoint --sas-token $sas_token -p $folder"

az storage file upload -s $share_name --source $path --account-name  $storage_account_name --file-endpoint "$storage_endpoint" --sas-token "$sas_token"  -p "$folder"

# Write outputs to deployment script output path
result=$(jq -n -c --arg relativePath $relative_path '{relativePath: $relativePath}')
echo relativePath result is $result >> $AZ_SCRIPTS_OUTPUT_PATH

# Delete uami generated before exiting the script
az identity delete --ids ${AZ_SCRIPTS_USER_ASSIGNED_IDENTITY}

# Update spring app environment
get_asa_env_update_result=$(az spring app update --resource-group %AZ_RESOURCE_GROUP% --service %AZ_SPRING_CLOUD% --name $MY_APP_NAME --env AZURE_KEYVAULT_ENABLED=$AZURE_KEYVAULT_ENABLED AZURE_KEYVAULT_URI=$AZURE_KEYVAULT_URI)
echo get_asa_env_update_result is $get_asa_env_update_result >> $AZ_SCRIPTS_OUTPUT_PATH

