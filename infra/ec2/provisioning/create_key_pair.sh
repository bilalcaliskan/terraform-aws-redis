#!/bin/bash

object_exists=$(aws s3api head-object --bucket BUCKET_NAME --key keys/ubuntu_ec2.pem || true)
if [ -z "$object_exists" ]; then
    echo "it does not exist, creating a fresh key pair and uploading to S3"
    ssh-keygen -t rsa -b 2048 -f /home/runner/ubuntu_ec2.pem -q -P ''
    ssh-keygen -y -f /home/runner/ubuntu_ec2.pem > /home/runner/ubuntu_ec2.pub
    aws s3api put-object --bucket BUCKET_NAME --key keys/ubuntu_ec2.pem --body /home/runner/ubuntu_ec2.pem
    aws s3api put-object --bucket BUCKET_NAME --key keys/ubuntu_ec2.pub --body /home/runner/ubuntu_ec2.pub
else
    echo "it exists, downloading existing key pair from S3"
    echo "y" | aws s3api get-object --bucket BUCKET_NAME --key keys/ubuntu_ec2.pem /home/runner/ubuntu_ec2.pem
    echo "y" | aws s3api get-object --bucket BUCKET_NAME --key keys/ubuntu_ec2.pub /home/runner/ubuntu_ec2.pub
fi

chmod 400 /home/runner/ubuntu_ec2.pem
chmod 400 /home/runner/ubuntu_ec2.pub
