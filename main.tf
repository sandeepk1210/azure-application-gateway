# Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "vm-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Custom Script Extension to install IIS and create Default.html in specific folders
resource "azurerm_virtual_machine_extension" "iis_extension" {
  count                = 2
  name                 = "iis-extension-${count.index + 1}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<SETTINGS
{
  "commandToExecute": "powershell -command \"Import-Module ServerManager; Add-WindowsFeature Web-Server; if (${count.index} -eq 0) { New-Item -ItemType Directory -Path 'C:\\inetpub\\wwwroot\\Images' -Force; Set-Content -Path 'C:\\inetpub\\wwwroot\\Images\\Default.html' -Value '<html><body><h1>Hello from VM 1.  This is image server.</h1></body></html>' } else { New-Item -ItemType Directory -Path 'C:\\inetpub\\wwwroot\\Videos' -Force; Set-Content -Path 'C:\\inetpub\\wwwroot\\Videos\\Default.html' -Value '<html><body><h1>Hello from VM 2.  This is video server.</h1></body></html>' }\""
}
SETTINGS
}

