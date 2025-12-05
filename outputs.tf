output "splunk_instances" {
  value = "Splunk instance available at: http://${module.ec2-instance.public_ip}:8000/"
}

output "splunk_creds" {
  value = "username: admin / password: SPLUNK-${module.ec2-instance.id}"
}
