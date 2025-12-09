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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.52.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2-instance"></a> [ec2-instance](#module\_ec2-instance) | terraform-aws-modules/ec2-instance/aws | 6.1.5 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.poc_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.hec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.in_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.splunk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.my_public_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_region"></a> [aws\_account\_region](#input\_aws\_account\_region) | Provide the desired AWS region (e.g. us-east-1, etc). | `string` | `"eu-west-1"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Provide the instance type (e.g. t3.small, etc). | `string` | `"t3.large"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Provide the name of the AWS public key. | `string` | `"erica-k"` | no |
| <a name="input_splunk_version"></a> [splunk\_version](#input\_splunk\_version) | Provide Splunk version. | `string` | `"9.4.4"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID. | `string` | `"subnet-fdc73bb4"` | no |
| <a name="input_ticket_id"></a> [ticket\_id](#input\_ticket\_id) | Provide an ID / name to identify the security group and the EC2. | `string` | `"fdse-3070"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | `"vpc-2c5fa94b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_splunk_creds"></a> [splunk\_creds](#output\_splunk\_creds) | n/a |
| <a name="output_splunk_instances"></a> [splunk\_instances](#output\_splunk\_instances) | n/a |
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
