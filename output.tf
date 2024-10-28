# Output the VM names
output "vm_names" {
  value = [for vm in azurerm_windows_virtual_machine.vm : vm.name]
}

# Output the Public IP addresses of the VMs
output "public_ips" {
  value = [for ip in azurerm_public_ip.public_ip : ip.ip_address]
}

# Output the admin username for VMs
output "admin_username" {
  value = azurerm_windows_virtual_machine.vm[0].admin_username
}

# Output the admin password from Key Vault
output "admin_password" {
  value     = azurerm_key_vault_secret.admin_password.value
  sensitive = true
}

# Output instructions to access each VM
output "access_instructions" {
  value = [
    for i, ip in azurerm_public_ip.public_ip : "Access VM-${i + 1} using RDP at ${ip.ip_address} with username 'adminuser' and password stored in the Key Vault."
  ]
}

# Outputs for accessing IIS hosted pages
output "vm1_iis_url" {
  value       = "http://${azurerm_public_ip.public_ip[0].ip_address}/Images/Default.html"
  description = "URL to access Default.html in Images folder on VM 1"
}

output "vm2_iis_url" {
  value       = "http://${azurerm_public_ip.public_ip[1].ip_address}/Videos/Default.html"
  description = "URL to access Default.html in Videos folder on VM 2"
}

# Output Application Gateway Public IP
output "appgw_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway_public_ip.ip_address
}

# Outputs for accessing IIS hosted pages via App Gateways
output "ag1_iis_url" {
  value       = "http://${azurerm_public_ip.app_gateway_public_ip.ip_address}/Images/Default.html"
  description = "URL to access Default.html via application gateway"
}

output "ag2_iis_url" {
  value       = "http://${azurerm_public_ip.app_gateway_public_ip.ip_address}/Videos/Default.html"
  description = "URL to access Default.html via application gateway"
}
