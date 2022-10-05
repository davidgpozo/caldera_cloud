#####################################
### Enviroment
#####################################
variable "az_subscription" {
  description = "The Azure subscription"
  type        = string
}

variable "az_resource_group" {
  description = "The Azure resource group name"
  type        = string
}

variable "az_localization" {
  description = "Localization of deployment"
  type        = string
}

variable "environment" {
  type = string
}
#####################################
### Networking
#####################################
variable "az_vnet_cidr" {
  type = list(string)
}

variable "az_subnets" {
  type    = list(string)
  default = []
}

variable "az_subnets_names" {
  type    = list(string)
  default = []
}

variable "az_prefix" {
  description = "Prefix for az resources names"
  type        = string
  default     = "redteam"
}

#####################################
### RSA keys
#####################################
variable "rsa_key_path" {
  type = string
}

variable "rsa_key_name" {
  type = string
}


#####################################
### Caldera server
#####################################
variable "az_caldera_name" {
  description = "Name for caldera server VM"
  type        = string
  default     = "caldera-server"
}
variable "az_caldera_server_private_ip" {
  description = "Private IP for caldera server"
  type        = string
  default     = "172.23.4.95"
}

variable "az_caldera_server_size" {
  description = "The size of the VM for Caldera server"
  type        = string
  default     = "Standard_DS1_v2"
}

#####################################
### Linux host
#####################################
variable "az_linux_host_name" {
  description = "Name for linux host VM"
  type        = string
  default     = "linux_host"
}

variable "az_linux_host_private_ip" {
  description = "Private IP for linux host"
  type        = string
  default     = "10.0.0.246"
}

variable "az_linux_host_size" {
  description = "The size of the VM for linux host"
  type        = string
  default     = "Standard_DS1_v2"
}


#####################################
### Windows host
#####################################

