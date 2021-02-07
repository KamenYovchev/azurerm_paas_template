#!/bin/bash
echo "************ Login in Azure with Service Principal"

# Variables data with credentials details
user_name=$1
un_password=$2
subscription=$3
environment=$4
db_username=$5
db_password=$6



##########################################
# Login to Azure with Service Principal
##########################################
echo $user_name
echo $un_password

az login -u $user_name -p $un_password
az account set --subscription $subscription
az config set extension.use_dynamic_install=yes_without_prompt

echo "************ Initialize Modules and configure backends"

# Initialize process
terraform init
######################################
#Set environment variables
######################################
 export TF_VAR_db_username=$db_username TF_VAR_db_password=$db_password
 echo $TF_VAR_db_username
 echo $TF_VAR_db_password

######################################
#Create workspace
######################################

echo "*********** Create or select workspace"
if [ $(terraform workspace list | grep -c "$environment") -eq 0 ] ; then
  echo "Create new workspace $environment"
  terraform workspace new "$environment" -no-color
else
  echo "Switch to workspace $environment"
  terraform workspace select "$environment" -no-color
fi


######################################
# Create a plan for resources
######################################

terraform plan  -out plan.tfplan

######################################
# Deploy resources to Azure
######################################

terraform apply plan.tfplan