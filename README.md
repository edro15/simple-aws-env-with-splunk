# Simple AWS Environment with Splunk installed

This repository contains Terraform configuration files used to provision an AWS EC2 instance and automatically install Splunk Enterprise.

Key features:
- An EC2 instance (`t3.large` by default) with Splunk installed (version `9.4.4` by default)
- Security group configured to allow traffic for your public IP on:
  - Splunk Web (default port `8000`)
  - Splunk Management (default port `8089`)
  - HTTP Event Collector (`HEC`, default port `8088`)

This project is intended for:
- Learning and experimentation with Splunk
- Demo environments
- Infrastructure-as-Code practice using Terraform

:point_right: It is not intended for production-grade Splunk deployments.

## Prerequisites
- An AWS account
- An AWS VPC
- An AWS subnet
- A public key for AWS EC2

## Getting Started

```bash
## Clone this repository
$~ git clone https://github.com/edro15/simple-aws-env-with-splunk.git
$~ cd simple-aws-env-with-splunk

## Set the Environment Variables
$~ cp .env-example .env
# Add your values to the required variables
$~ vi .env
# Load the environment variables
$~ source .env

## Configure the deployment
$~ cp terraform.tfvars.example terraform.tfvars
# Edit the variables opportunely
$~ vi terraform.tfvars
```

For more details on the variables check [documentation](#documentation) below

:point_right: List of [available Splunk AMIs](https://aws.amazon.com/marketplace/pp/B00PUXWXNE) to verify existing versions

### Usage

```bash
# Initialize the terraform providers
$~ terraform init

# Preview the changes that terraform plans to make to your infrastructure
$~ terraform plan

# Deploy (--auto-approve to avoid being prompted to confirm the changes)
$~ terraform apply
```

Splunk URL and access credentials will be displayed as soon as the process is completed.
> It may take up to ~5 minutes for Splunk to be up and running

## Documentation
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Troubleshooting
If you haven't yet subscribed for the AWS Marketplace subscription for the Splunk Enterprise AMI, you will
be most likely receive an error message similar to this one:

![Image](./docs/img/error.png)


```bash
# 1. Cancel the deployment (--auto-approve to avoid being prompted to confirm the changes)
$~ terraform destroy
# 2. Browse to the link in the error message
# 3. Sign up for the Splunk AMI in the AWS Console
# 4. Apply the deployment again
$~ terraform apply
```

## Credits
* [Another terraform module](https://github.com/nvibert/terraform-aws-splunk) to deploy Splunk Enterprise on AWS EC2
* This project was forked from [this extensive automation](https://github.com/sschimper-splunk/simple-aws-env-with-splunk)

Thank you for the inspiration! :rocket: :heart:

## References

* [Splunk Enterprise AMI](https://help.splunk.com/en/data-management/splunk-enterprise-admin-manual/10.0/meet-the-splunk-ami/about-the-splunk-enterprise-ami)
* [Terraform CLI](https://developer.hashicorp.com/terraform/cli/run)