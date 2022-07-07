variable "region" {
  description = "AWS region"
  type        = string
}

variable "rsa_bits" {
  description = "Name for the ssh key"
  type        = string
  default     = "4096"
}

variable "rsa_key_name" {
  description = "Name for the ssh key"
  type        = string
}

variable "write_ssh_key" {
  description = "If write ssh key on local execution path"
  type = bool
  default = false
}