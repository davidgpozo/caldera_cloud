#############################################################################
### Gen SSH key for workers EKS Cluster
#############################################################################
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "worker" {
  key_name   = var.rsa_key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "ssh_local" {
    count    = var.write_ssh_key ? 1 : 0
    content  = tls_private_key.ssh_key.public_key_openssh
    filename = "${path.cwd}/ssh_key"
}