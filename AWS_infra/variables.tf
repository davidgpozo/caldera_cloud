#####################################
### Enviroment
#####################################
variable "aws_region_name" {
  type = string
}

variable "aws_zones_names" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "aws_profile" {
  type        = string
  description = "Profile name of aws resource"
  default     = "default"
}


variable "tags" {
  description = "A map with Tags to tagging resources"
  type        = map(string)
  default = {
    "Lab" = "caldera"
  }
}


#####################################
### Networking
#####################################

variable "aws_vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  type    = list(string)
  default = []
}


variable "database_subnets" {
  type    = list(string)
  default = []
}


variable "redshift_subnets" {
  type    = list(string)
  default = []
}

#####################################
### RSA keys var for EKS
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
variable "caldera_server_ami" {
  description = "AMI for caldera server"
  type        = string
  default     = "ami-0817d428a6fb68645"
}

variable "caldera_server_instance_type" {
  description = "Instance type for caldera server"
  type        = string
  default     = "t2.micro"
}

variable "caldera_server_private_ip" {
  description = "Private IP for caldera server"
  type        = string
  default     = "172.23.0.95"
}

#####################################
### Linux host
#####################################
variable "linux_host_ami" {
  description = "AMI for Linux host"
  type        = string
  default     = "ami-0817d428a6fb68645"
}

variable "linux_host_instance_type" {
  description = "Instance type for linux host"
  type        = string
  default     = "t2.micro"
}

variable "linux_host_private_ip" {
  description = "Private IP for linux host"
  type        = string
  default     = "172.23.32.95"
}

#####################################
### Windows host
#####################################
variable "windows_host_ami" {
  description = "AMI for windows host"
  type        = string
  default     = "ami-07d78b8d1764fbfbb"
}

variable "windows_host_instance_type" {
  description = "Instance type for windows host"
  type        = string
  default     = "t2.micro"
}

variable "windows_host_private_ip" {
  description = "Private IP for linux host"
  type        = string
  default     = "172.23.64.95"
}
