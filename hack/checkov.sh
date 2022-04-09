#!/bin/bash

terraform init -input=false
terraform plan -input=false -out tf.plan
terraform show -json tf.plan > tf.json
checkov -f tf.json --soft-fail-on CKV_AWS_126,CKV_AWS_24 --framework terraform_plan