#!/bin/bash

bucket_exists=$(aws s3api head-bucket --bucket BUCKET_NAME --region AWS_REGION 2>&1 || true)
if [ ! -z "$bucket_exists" ]; then
    echo "bucket BUCKET_NAME does not exists on region AWS_REGION, creating an empty bucket"
    response=$(aws s3api create-bucket --bucket BUCKET_NAME --region AWS_REGION)
    if [[ $? -ne 0 ]]; then
        echo "ERROR: AWS reports create-bucket operation failed.\n$response"
        exit 1
    fi
    echo "successfully created bucket BUCKET_NAME on region AWS_REGION"
else
    echo "bucket BUCKET_NAME already exists on region AWS_REGION, skipping"
fi

object_exists=$(aws s3api head-object --bucket BUCKET_NAME --region AWS_REGION --key keys/redis/redis_ec2.pem || true)
if [ -z "$object_exists" ]; then
    echo "key pair does not exist on bucket BUCKET_NAME, creating a fresh key pair and uploading to S3"
    ssh-keygen -t rsa -b 2048 -f /home/runner/redis_ec2.pem -q -P ''
    ssh-keygen -y -f /home/runner/redis_ec2.pem > /home/runner/redis_ec2.pub
    aws s3api put-object --region AWS_REGION --bucket BUCKET_NAME --key keys/redis/redis_ec2.pem --body /home/runner/redis_ec2.pem
    aws s3api put-object --region AWS_REGION --bucket BUCKET_NAME --key keys/redis/redis_ec2.pub --body /home/runner/redis_ec2.pub
else
    echo "key pair exists on bucket BUCKET_NAME, downloading existing key pair from S3"
    echo "y" | aws s3api get-object --region AWS_REGION --bucket BUCKET_NAME --key keys/redis/redis_ec2.pem /home/runner/redis_ec2.pem
    echo "y" | aws s3api get-object --region AWS_REGION --bucket BUCKET_NAME --key keys/redis/redis_ec2.pub /home/runner/redis_ec2.pub
fi

chmod 400 /home/runner/redis_ec2.pem
chmod 400 /home/runner/redis_ec2.pub
