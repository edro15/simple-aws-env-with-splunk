##############################
# AWS variables
##############################

variable "vpc_id" {
  default     = "vpc-2c5fa94b"
  description = "VPC ID."
}

variable "subnet_id" {
  default     = "subnet-fdc73bb4"
  description = "Subnet ID."
}

variable "aws_account_region" {
  description = "Provide the desired AWS region (e.g. us-east-1, etc)."
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Provide the instance type (e.g. t3.small, etc)."
  type        = string
  default     = "t3.large"
}

variable "splunk_version" {
  description = "Provide Splunk version."
  type        = string
  default     = "9.4.4"
}

variable "ticket_id" {
  description = "Provide an ID / name to identify the security group and the EC2."
  type        = string
  default     = "fdse-3070"
}

variable "key_name" {
  description = "Provide the name of the AWS public key."
  type        = string
  default     = "erica-k"
}