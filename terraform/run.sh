#!/usr/bin/env bash

aws events disable-rule --name "SG-Enforcer-Stack-TriggeredRuleForSecurityGroupCha-13794XN378YQ1"

cd terraform

ECR_REPO_NAME="jmeter"

aws configure set aws_access_key_id $1
aws configure set aws_secret_access_key $2
aws configure set region $4

ACCOUNT_ID=$3

ECR_URL="${ACCOUNT_ID}.dkr.ecr.eu-central-1.amazonaws.com"
ECR_PATH="$ECR_URL/$ECR_REPO_NAME"

login=$(aws ecr get-login --region eu-central-1)
user=`echo $login | cut -d " " -f4`
password=`echo $login | cut -d " " -f6`
login=`echo $login | cut -d " " -f1,2,3,4,5,6,9`
eval $login

aws ecr create-repository --repository-name ${ECR_REPO_NAME:?} || true

export dockerrepository=$ECR_URL
export dockeruser=$user
export dockerpassword=$password

pwd; ls -l
cd ..
pwd; ls -l
packer build template.json
aws events enable-rule --name "SG-Enforcer-Stack-TriggeredRuleForSecurityGroupCha-13794XN378YQ1"
