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
  depends_on        = [module.vnet]
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
  name                = "${var.az_prefix}-${var.az_caldera_server_name}-nsg"
  resource_group_name = var.az_resource_group
  location            = var.az_localization

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
  security_rule  {
    name                       = "api-rule"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2288"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "caldera_public_ip" {
  name                    = "${var.az_prefix}-${var.az_caldera_server_name}-ip"
  location                = var.az_localization
  resource_group_name     = var.az_resource_group
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "caldera_nic" {
  name                = "${var.az_prefix}-${var.az_caldera_name}-nic"
  location            = var.az_localization
  resource_group_name = var.az_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.caldera_public_ip.id
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
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202206160"
  }
  depends_on = [azurerm_network_interface.caldera_nic,
    data.azurerm_ssh_public_key.existing_ssh,
  azurerm_network_security_group.caldera_nsg]
}


#############################################################################
### Linux host
#############################################################################
resource "azurerm_network_security_group" "linux_nsg" {
  name                = "${var.az_prefix}-${var.az_linux_host_name}-nsg"
  resource_group_name = var.az_resource_group
  location            = var.az_localization
  #  depends_on          = [module.vnet]

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

resource "azurerm_network_interface" "linux_nic" {
  name                = "${var.az_prefix}-${var.az_caldera_name}-nic"
  location            = var.az_localization
  resource_group_name = var.az_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_public_ip.caldera_public_ip]
}


resource "azurerm_linux_virtual_machine" "linux_host" {
  name                = "${var.az_prefix}-${var.az_linux_host_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_localization
  size                = var.az_linux_host_size
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.linux_nic.id
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
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202206160"
  }
  depends_on = [azurerm_network_interface.linux_nic,
    data.azurerm_ssh_public_key.existing_ssh,
    azurerm_network_security_group.linux_nsg]
}

#############################################################################
### Windows host
#############################################################################
## To be build