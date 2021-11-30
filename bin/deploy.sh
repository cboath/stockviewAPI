#!/bin/bash

GREEN='\033[1;32m'
SMILE='\xE2\x98\xBB'
NC='\033[0m'

if [ -z "$1" ]
    then
        echo "Release not provided"
        exit
fi

. .deploy

export TEMPLATE_FILE=$TEMPLATE
export PARAMETERS_FILE=$PARAMETERS
export TAGS=$TAGS
export STACK_NAME=$STACK_NAME
export BUCKET_NAME=$BUCKET_NAME

echo "Checking S3 bucket exists..."                                                                                                                                                                                                           
BUCKET_EXISTS=true                                                                                                                                                                                                                            
S3_CHECK=$(aws s3 ls "s3://${BUCKET_NAME}" 2>&1)    

if [ $? != 0 ]                                                                                                                                                                                                                                
then                                                                                                                                                                                                                                          
  NO_BUCKET_CHECK=$(echo $S3_CHECK | grep -c 'NoSuchBucket')                                                                                                                                                                                     
  if [ $NO_BUCKET_CHECK = 1 ]; then                                                                                                                                                                                                              
    echo "Bucket does not exist.  Creating" 
    aws s3api create-bucket --bucket $BUCKET_NAME                                                                                                                                                                                                                
  else                                                                                                                                                                                                                                        
    echo "Error checking S3 Bucket"                                                                                                                                                                                                           
    echo "$S3_CHECK"                                                                                                                                                                                                                          
    exit 1                                                                                                                                                                                                                                    
  fi 
else                                                                                                                                                                                                                                         
  echo "Bucket exists"
fi

mkdir -p dist/${1}/src
mkdir -p dist/${1}/stage

echo "Copying template to S3 bucket"
aws s3 cp cloudformation.yaml s3://$BUCKET_NAME/${1}/cloudformation.yaml
cp cloudformation.yaml dist/$1/cloudformation.yaml

echo "Copying Parameters to S3 bucket"
aws s3 cp parameters/stocks.json s3://$BUCKET_NAME/${1}/stocks.json
cp parameters/stocks.json dist/$1/stocks.json

#Prepare Lambda
rm -rf dist/${1}/src/*
./bin/install-and-prune.sh $1 /

printf "\n ${GREEN}${SMILE} All functions packaged!${NC}\n\n"

#Copy Lambdas
aws s3 cp --recursive --exclude "*.DS*" dist/${1}/stage s3://${BUCKET_NAME}/$1/lambda-src/

echo "Deploying stack ${STACK_NAME}"
./bin/deploy/deploy-stack.sh $1

read -p "Check the AWS console for build status.  Press any key to continue."