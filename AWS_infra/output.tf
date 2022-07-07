#output "bastion_ssh_connect" {
#  value = "ubuntu@${aws_instance.bastion.public_dns}"
#}

output "rsa_private_key" {
  value = nonsensitive(module.aws_rsa_key.private_rsa_key)
}

output "caldera_server_ip" {
  value = aws_instance.caldera_server.public_ip
}

output "linux_host_ip" {
  value = aws_instance.linux_host.private_ip
}

output "windows_host_ip" {
  value = aws_instance.windows_host.private_ip
}