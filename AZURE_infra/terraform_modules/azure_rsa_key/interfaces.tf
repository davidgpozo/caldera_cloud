variable "az_location" {
  description = "Azure localization"
  type        = string
}

variable "az_resource_group" {
  description = "Azure resource group"
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