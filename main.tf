######################
# AWS Infrastructure #
######################

# Get My Public IP
data "http" "my_public_ip" {
  url = "https://ipinfo.io/json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  my_public_ip = format("%s/32", jsondecode(data.http.my_public_ip.response_body).ip)
}

# Security Group
resource "aws_security_group" "poc_security_group" {
  name        = "splunk-sg-${var.ticket_id}"
  description = "Allowing inbound traffic for ports 8000, 22, and 443"
  vpc_id      = var.vpc_id
}

# Security Group Outbound Rule - Allows all traffic outbound
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 22 SSH
resource "aws_security_group_rule" "in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_public_ip]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 8000
resource "aws_security_group_rule" "web" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = [local.my_public_ip]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 80 HTTP
# resource "aws_security_group_rule" "in_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.poc_security_group.id
# }

# Security Group Inbound Rule - Port 443 HTTPS
# resource "aws_security_group_rule" "in_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.poc_security_group.id
# }

# Security Group Inbound Rule - Port 9997 Splunk Receiver
# resource "aws_security_group_rule" "receiver" {
#   type              = "ingress"
#   from_port         = 9997
#   to_port           = 9997
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.poc_security_group.id
# }

# Security Group Inbound Rule - Port 8088 Splunk Receiver
resource "aws_security_group_rule" "hec" {
  type      = "ingress"
  from_port = 8088
  to_port   = 8088
  protocol  = "tcp"
  cidr_blocks = [
    local.my_public_ip,
    "1.1.1.1/32"
  ]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 8089 Splunk Receiver
resource "aws_security_group_rule" "mgmt" {
  type              = "ingress"
  from_port         = 8089
  to_port           = 8089
  protocol          = "tcp"
  cidr_blocks       = [local.my_public_ip]
  security_group_id = aws_security_group.poc_security_group.id
}

# EC2 Instance
data "aws_ami" "splunk" {
  most_recent = true
  owners      = ["679593333241"] ## Splunk Account

  filter {
    name   = "name"
    values = ["splunk_AMI_${var.splunk_version}*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.5"

  name = "${var.ticket_id}-ec2"

  ami                    = data.aws_ami.splunk.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.poc_security_group.id]
  subnet_id              = var.subnet_id

  root_block_device = {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 100
  }

  tags = {
    splunkit_environment_type    = "non-prd"
    splunkit_data_classification = "private"
    Name                         = var.ticket_id
  }

  # Run commands at Splunk boot
  # user_data = file("./my_script.sh")
}
