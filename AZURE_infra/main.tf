#############################################################################
### Resource group
#############################################################################
#resource "azurerm_resource_group" "temp" {
#  name     = var.az_resource_group
#  location = var.az_localization
#}

#############################################################################
### VNET
#############################################################################

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 2.6.0"
  vnet_location       = var.az_localization
  resource_group_name = var.az_resource_group
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
module "azure_rsa_key" {
  source            = "./terraform_modules/azure_rsa_key"
  az_location       = var.az_localization
  az_resource_group = var.az_resource_group
  rsa_key_name      = var.rsa_key_name
  #  depends_on        = [module.vnet]
}

data "azurerm_ssh_public_key" "existing_ssh" {
  name                = module.azure_rsa_key.ssh_public_name
  resource_group_name = var.az_resource_group
  depends_on          = [module.azure_rsa_key]
}

#############################################################################
### Caldera server
#############################################################################
resource "azurerm_network_security_group" "caldera_nsg" {
  name                = "${var.az_prefix}-${var.az_caldera_name}-nsg"
  resource_group_name = var.az_resource_group
  location            = var.az_localization
  depends_on          = [module.vnet]

  security_rule {
    name                       = "ssh-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_public_ip" "caldera_public_ip" {
  name                    = "caldera_pub_ip"
  location                = var.az_localization
  resource_group_name     = var.az_resource_group
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.environment
  }
  depends_on = [module.vnet]
}

resource "azurerm_network_interface" "caldera_nic" {
  name                = "${var.az_prefix}-${var.az_caldera_name}-nic"
  location            = var.az_localization
  resource_group_name = var.az_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Static"
  }

  ip_configuration {
    name                          = "public"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.caldera_public_ip.id
    primary = true
  }

  depends_on = [azurerm_public_ip.caldera_public_ip]
}

resource "azurerm_linux_virtual_machine" "caldera_server" {
  name                = "${var.az_prefix}-${var.az_caldera_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_localization
  size                = var.az_caldera_server_size
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.caldera_nic.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = data.azurerm_ssh_public_key.existing_ssh.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202108250"
  }
  depends_on = [azurerm_network_interface.caldera_nic,
    data.azurerm_ssh_public_key.existing_ssh,
  azurerm_network_security_group.caldera_nsg]
}

#module "virtual_machine" {
#  source = "git::https://shefirot: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@github.com/pagonxt/terraform-azurerm-vm-linux?ref=master"
#
#  # Workload Environmet variables
#  resource_group         = var.az_resource_group
#  resource_group_kvt_sta = var.az_resource_group
#  resource_group_lwk     = var.az_resource_group
#  resource_group_vault   = var.az_resource_group
#  #End Workload Environmet variables
#
#  # Common product variables
#  vnet_resource_group_name       = module.vnet.vnet_name
# # resource_group_platform        = ""
# lwk-name                       = "abc"
#  location                       = var.az_localization
#  #kvt-name                       = "abc"
#  #boot_diagnostic_storageaccount = "abc"
#  #End Common product variables
#
#  #nsg variable
#  network_interface_nsg = azurerm_network_security_group.nsg.id
#  #vm product variables
#  name                 = "detd1weugvml-caldera-server"
#  vm_size              = "Standard_DS1_v2"
#  vm_count             = 1
#  os_disk_caching      = "ReadOnly"
#  managed_os_disk_type = "Standard_LRS"
#  admin_username       = "admin-terraform"
#  zones                = ["1", "2", "3"]
#  offset               = 1
# # vault-name           = "abc"
# # policy-name          = "abc"
#
#  add_backup              = false
#  install_dynatrace_agent = false
#
#
#  #Marketplace VM vars
#  custom_image_name    = "Ubuntu_Server_20.04_LTS"
#  custom_image         = false
#  gallery_image        = true
#  #custom_image_version = "abc"
#  #Marketplace End VM vars
#
#  #nic
#  network_interface_subnets   = [module.vnet.vnet_subnets]
#  network_interface_vnet_name = module.vnet.vnet_name
#  network_interface_location  = var.az_localization
#  network_interface_rsg       = var.az_resource_group
#  static_ip                   = "true"
#  private_ip_addresses        = [var.caldera_server_private_ip]
#  #End nic
#
#  #End vm product variables
#
#  #Custom tags
#  #  cost_center = ""
#  #  confideniality = "C"
#  #End Custom tags
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
