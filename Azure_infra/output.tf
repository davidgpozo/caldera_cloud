#output "rsa_private_key" {
#  value = nonsensitive(module.aws_rsa_key.private_rsa_key)
#}
#
#output "caldera_server_ip" {
#  value = aws_instance.caldera_server.public_ip
#}
#
#output "caldera_server_id" {
#  value = aws_instance.caldera_server.id
#}
#
#output "linux_host_ip" {
#  value = aws_instance.linux_host.private_ip
#}
#
#output "linux_host_id" {
#  value = aws_instance.linux_host.id
#}
#
#output "windows_host_ip" {
#  value = aws_instance.windows_host.private_ip
#}
#
#output "windows_host_id" {
#  value = aws_instance.windows_host.id
#}
