#!/bin/bash

# object_exists=$(aws s3api head-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem || true)
# if [ -z "$object_exists" ]; then
aws s3 ls s3://<BUCKET_NAME>/keys/ubuntu_ec2.pem
if [[ $? -ne 0 ]]; then
    echo "it does not exist, creating a fresh key pair and uploading"
    ssh-keygen -t rsa -b 2048 -f /tmp/ubuntu_ec2.pem -q -P ''
    ssh-keygen -y -f /tmp/ubuntu_ec2.pem > /tmp/ubuntu_ec2.pub
    aws s3api put-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem --body /tmp/ubuntu_ec2.pem
    aws s3api put-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pub --body /tmp/ubuntu_ec2.pub
else
    echo "it exists, downloading existing"
    echo "y" | aws s3api get-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pem /tmp/ubuntu_ec2.pem
    echo "y" | aws s3api get-object --bucket <BUCKET_NAME> --key keys/ubuntu_ec2.pub /tmp/ubuntu_ec2.pub
fi

chmod 600 /tmp/ubuntu_ec2.pem
chmod 600 /tmp/ubuntu_ec2.pub
