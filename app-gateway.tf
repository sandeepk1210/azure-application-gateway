# Create application gateway
resource "azurerm_application_gateway" "app_gateway" {
  name                = "application-gateway"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  # Backend address pools for images and videos
  backend_address_pool {
    name = "image-backend-pool"
    ip_addresses = [
      azurerm_network_interface.nic[0].private_ip_address
    ]
  }

  backend_address_pool {
    name = "video-backend-pool"
    ip_addresses = [
      azurerm_network_interface.nic[1].private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "appgw-image-http-set1"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  backend_http_settings {
    name                  = "appgw-video-http-set1"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  # URL Path Map
  url_path_map {
    name                               = "testgateway-url-path"
    default_backend_address_pool_name  = "image-backend-pool"
    default_backend_http_settings_name = "appgw-image-http-set1"

    path_rule {
      name                       = "api"
      paths                      = ["/images/*"]
      backend_address_pool_name  = "image-backend-pool"
      backend_http_settings_name = "appgw-image-http-set1"
    }

    path_rule {
      name                       = "videos"
      paths                      = ["/videos/*"]
      backend_address_pool_name  = "video-backend-pool"
      backend_http_settings_name = "appgw-video-http-set1"
    }
  }

  request_routing_rule {
    name               = "url-path-routing-rule"
    rule_type          = "PathBasedRouting"
    http_listener_name = "appgw-http-listener"
    priority           = 1 # Priority for the rule

    # Assign the URL path map
    url_path_map_name = "testgateway-url-path"
  }
}

