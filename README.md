## Prerequisites

Terraform version >= v0.15.5

## Describe Modules

## Module network

This module create VPC, public and private subnets, NAT, route tables for subnets

## Module bastion

This module create bastion host, security group, cloud watch group for it 

## Module websrv

This module create webapp host, security group, cloud watch group for it

## How to run?

1. Clone this repository on your local machine
2. Create file main.tf(where you specify which of modules you want to use)
3. Create file terraform.tfvars - put there value for variables
4. Load credentials of your AWS account(access key, secret key)
    ```zsh
    export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXX
    export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXX
    ```
   or configure aws cli
5. After that you can write nex command:
    ```zsh
    terraform plan - try to apply your configuration and show if there any mistakes

    terraform apply - apply your configuraton. Also terraform ask you to confirm that you want to create this configuraton.

    terraform destroy - destroy your configuraton according to .tfstate file. Also terraform ask you to confirm that you want to destroy this configuraton.
    ```



