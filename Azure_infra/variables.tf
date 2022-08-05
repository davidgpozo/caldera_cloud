#####################################
### Enviroment
#####################################
variable "az_subscription" {
  description = "The Azure subscription"
  type        = string
}

variable "az_resource_name" {
  description = "The Azure resource name"
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

#####################################
### RSA keys
#####################################


#####################################
### Caldera server
#####################################

#####################################
### Linux host
#####################################


#####################################
### Windows host
#####################################

