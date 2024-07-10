#!/bin/bash

export TF_WORKSPACE=workspace-staging
terraform init

while true; do
    if [ -d ".terraform" ]; then
        terraform apply -var-file=staging.auto.tfvars
        break
    else
        echo "Terraform has not been initialized. Waiting for initialization..."
        sleep 5
    fi
done