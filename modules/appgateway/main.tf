# ─────────────────────────────────────────────────────────────────────────────
# MODULE: APPLICATION GATEWAY  (Week 3)
# Standard_v2 (WAF_v2 costs more — swap sku if WAF lab is needed)
# Path-based routing: /app -> pool-app, /api -> pool-api
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

locals {
  # Named objects referenced across the resource
  fe_ip_name       = "fe-ip"
  fe_port_name     = "fe-port-80"
  listener_name    = "listener-http"
  pool_app_name    = "pool-app"
  pool_api_name    = "pool-api"
  http_setting     = "http-setting"
  routing_rule     = "routing-rule"
  url_path_map     = "path-map"
}

resource "azurerm_application_gateway" "this" {
  name                = "appgw-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.appgw_sku
    tier     = var.appgw_sku  # Standard_v2 or WAF_v2
    capacity = 1              # minimum for cost control on free account
  }

  gateway_ip_configuration {
    name      = "gw-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = local.fe_ip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.fe_port_name
    port = 80
  }

  backend_address_pool {
    name = local.pool_app_name
  }

  backend_address_pool {
    name = local.pool_api_name
  }

  backend_http_settings {
    name                  = local.http_setting
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.fe_ip_name
    frontend_port_name             = local.fe_port_name
    protocol                       = "Http"
  }

  url_path_map {
    name                               = local.url_path_map
    default_backend_address_pool_name  = local.pool_app_name
    default_backend_http_settings_name = local.http_setting

    path_rule {
      name                       = "app-rule"
      paths                      = ["/app/*"]
      backend_address_pool_name  = local.pool_app_name
      backend_http_settings_name = local.http_setting
    }

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.pool_api_name
      backend_http_settings_name = local.http_setting
    }
  }

  request_routing_rule {
    name               = local.routing_rule
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
    url_path_map_name  = local.url_path_map
    priority           = 100
  }
}
