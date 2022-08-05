#############################################################################
### VNET
#############################################################################
#resource "azurerm_resource_group" "example" {
#  name     =  var.az_resource_name
#  location =  var.az_localization
#}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 2.6.0"
  vnet_location = var.az_localization
  resource_group_name = var.az_resource_name
  address_space       = var.az_vnet_cidr
  subnet_prefixes     = var.az_subnets
  subnet_names        = var.az_subnets_names

  tags = {
    environment = var.environment
  }

}


#############################################################################
### Gen RSA Key for EKS
#############################################################################
#module "aws_rsa_key" {
#  source       = "./terraform_modules/aws_rsa_key"
#  region       = var.aws_region_name
#  rsa_key_name = var.rsa_key_name
#  depends_on   = [module.vpc]
#}


#############################################################################
### Caldera server
#############################################################################
#resource "aws_security_group" "sg_caldera_server" {
#  name        = "sg_caldera_server"
#  description = "Allow ports for caldera server"
#  vpc_id      = module.vpc.vpc_id
#
#  ingress {
#    description = "SSH from VPC"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    description = "Caldera server port"
#    from_port   = 2288
#    to_port     = 2288
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  #  ingress {
#  #    description = "Caldera server contact tcp port"
#  #    from_port   = 7010
#  #    to_port     = 7010
#  #    protocol    = "tcp"
#  #    cidr_blocks = ["0.0.0.0/0"]
#  #  }
#  #
#  #  ingress {
#  #    description = "Caldera server contact udp port"
#  #    from_port   = 7011
#  #    to_port     = 7011
#  #    protocol    = "udp"
#  #    cidr_blocks = ["0.0.0.0/0"]
#  #  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    environment = var.environment
#  }
#}
#
#resource "aws_instance" "caldera_server" {
#  ami                         = var.caldera_server_ami
#  instance_type               = var.caldera_server_instance_type
#  associate_public_ip_address = true
#  subnet_id                   = element(module.vpc.public_subnets, 0)
#  vpc_security_group_ids      = [aws_security_group.sg_caldera_server.id]
#  key_name                    = var.rsa_key_name
#  #  user_data                   = file("files/install_caldera_server.sh")
#  depends_on = [module.aws_rsa_key]
#  private_ip = var.caldera_server_private_ip
#  tags = {
#    environment = var.environment
#    Name        = "caldera_server"
#  }
#}

#############################################################################
### Linux host
#############################################################################
#resource "aws_security_group" "sg_caldera_linux" {
#  name        = "sg_caldera_linux"
#  description = "Allow ssh access for linux host"
#  vpc_id      = module.vpc.vpc_id
#
#  ingress {
#    description = "SSH port"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["172.23.0.0/16"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    environment = var.environment
#  }
#
#}
#
#resource "aws_instance" "linux_host" {
#  ami                    = var.linux_host_ami
#  instance_type          = var.linux_host_instance_type
#  subnet_id              = element(module.vpc.private_subnets, 1)
#  vpc_security_group_ids = [aws_security_group.sg_caldera_linux.id]
#  key_name               = var.rsa_key_name
#  user_data              = file("files/install_linux_host.sh")
#  depends_on = [module.aws_rsa_key, aws_instance.caldera_server, aws_instance.caldera_server]
#  private_ip = var.linux_host_private_ip
#
#  tags = {
#    environment = var.environment
#    Name        = "linux_host"
#  }
#}

#############################################################################
### Windows host
#############################################################################
#resource "aws_security_group" "sg_caldera_windows" {
#  name        = "sg_caldera_windows"
#  description = "Allow RDP for windows host"
#  vpc_id      = module.vpc.vpc_id
#
#  ingress {
#    description = "RDP port"
#    from_port   = 3389
#    to_port     = 3389
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    environment = var.environment
#  }
#
#}
#
#resource "aws_instance" "windows_host" {
#  ami                    = var.windows_host_ami
#  instance_type          = var.windows_host_instance_type
#  subnet_id              = element(module.vpc.private_subnets, 2)
#  vpc_security_group_ids = [aws_security_group.sg_caldera_windows.id]
#  key_name               = var.rsa_key_name
#  user_data              = file("files/install_windows_host.ps1")
#  depends_on             = [module.aws_rsa_key, aws_instance.caldera_server]
#  private_ip             = var.windows_host_private_ip
#  tags = {
#    environment = var.environment
#    Name        = "windows_host"
#  }
#}
