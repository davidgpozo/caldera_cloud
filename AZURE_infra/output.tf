#############################################################################
### Common outputs
#############################################################################
output "rsa_private_key" {
  description = "Private key to access nodes"
  value = nonsensitive(module.azure_rsa_key.private_rsa_key)
}

output "authorized_keys" {
  description = "Authorized key to add nodes"
  value = data.azurerm_ssh_public_key.existing_ssh.public_key
}

#############################################################################
### Caldera server outputs
#############################################################################
output "caldera_server_public_ip_id" {
  description = "Public caldera IP id to associate public ip to nic"
  value = azurerm_public_ip.caldera_public_ip.id
}

output "caldera_server_ip" {
  description = "Caldera server IP to access"
  value = azurerm_public_ip.caldera_public_ip.ip_address 
}

output "caldera_server_int_ip" {
  description = "Internal caldera server IP"
  value = azurerm_linux_virtual_machine.caldera_server.private_ip_address
}
#############################################################################
### Linux host outputs
#############################################################################
output "linux_host_ip" {
  description = "Internal linux host address"
  value = azurerm_linux_virtual_machine.linux_host.private_ip_address
}