module "aws_rsa_key" {
  region = "us-east-1"
  source = "../../"
  rsa_key_name = "kube-node"
  write_ssh_key = true
}

output "ssh_key" {
#  value = nonsensitive(module.aws_rsa_key.private_rsa_key)
  value = module.aws_rsa_key.private_rsa_key
  sensitive = true
}