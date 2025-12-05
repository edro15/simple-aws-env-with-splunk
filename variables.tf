##############################
# AWS variables
##############################

variable "vpc_id" {
  default     = "vpc-2c5fa94b"
  description = "VPC ID"
}

variable "subnet_id" {
  default     = "subnet-fdc73bb4"
  description = "Subnet ID"
}

variable "aws_account_region" {
  description = "Provide the desired region"
  default     = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "splunk_version" {
  type    = string
  default = "9.4.4"
}

variable "ticket_id" {
  type    = string
  default = "fdse-3070"
}

variable "key_name" {
  type    = string
  default = "erica-k"
}