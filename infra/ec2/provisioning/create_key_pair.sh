#!/bin/bash

object_exists=$(aws s3api head-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem || true)
if [ -z "$object_exists" ]; then
    echo "it does not exist, creating a fresh key pair and uploading"
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/ubuntu_ec2.pem -q -P ''
    ssh-keygen -y -f ~/.ssh/ubuntu_ec2.pem > ~/.ssh/ubuntu_ec2.pub
    aws s3api put-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem --body ~/.ssh/ubuntu_ec2.pem
    aws s3api put-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pub --body ~/.ssh/ubuntu_ec2.pub
else
    echo "it exists, downloading existing"
    echo "y" | aws s3api get-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem ~/.ssh/ubuntu_ec2.pem
    echo "y" | aws s3api get-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pub ~/.ssh/ubuntu_ec2.pub
fi

chmod 600 ~/.ssh/ubuntu_ec2.pem
chmod 600 ~/.ssh/ubuntu_ec2.pub
