resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Generate an SSH key pair
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an Azure Virtual Machine
resource "azurerm_virtual_machine" "linux_vm" {
  name                  = "example-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1ls"
  depends_on = [ azurerm_resource_group.resource_group ]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/adminuser/.ssh/authorized_keys"
    }
  }
}

# Creates a managed disk for the VM

resource "azurerm_managed_disk" "disk" {
  name                 = "example-disk"
  location            = var.location
  resource_group_name = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  depends_on = [ azurerm_virtual_machine.linux_vm ]
}

# Attach the Managed Disk to the Virtual Machine
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_virtual_machine.linux_vm.id
  lun                = 0
  caching            = "ReadWrite"
  depends_on = [ azurerm_virtual_machine.linux_vm ]
}