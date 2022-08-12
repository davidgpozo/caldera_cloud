output "private_rsa_key" {
  value = tls_private_key.ssh_key.private_key_pem
}

output "ssh_public_name" {
  value = azurerm_ssh_public_key.worker.name
}
