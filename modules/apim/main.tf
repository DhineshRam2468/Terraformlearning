# ─────────────────────────────────────────────────────────────────────────────
# MODULE: API MANAGEMENT  (Week 5)
# Consumption tier = near-zero cost, instant provisioning (vs 30-45 min for Developer tier)
# Includes a mock echo API so you can test immediately
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_api_management" "this" {
  name                = "apim-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "${var.apim_sku}_${var.apim_capacity}"   # e.g. "Consumption_0"
  tags                = var.tags
}

# ── Mock API (httpbin-style echo API for testing) ─────────────────────────────
resource "azurerm_api_management_api" "echo" {
  name                = "echo-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Echo API"
  path                = "echo"
  protocols           = ["https"]
  service_url         = "https://httpbin.org"

  subscription_required = false
}

resource "azurerm_api_management_api_operation" "get" {
  operation_id        = "get-anything"
  api_name            = azurerm_api_management_api.echo.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  display_name        = "GET Anything"
  method              = "GET"
  url_template        = "/anything"

  response {
    status_code = 200
  }
}

# ── Policy: add a custom header on every request ──────────────────────────────
resource "azurerm_api_management_api_policy" "echo" {
  api_name            = azurerm_api_management_api.echo.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-header name="X-Training-Source" exists-action="override">
      <value>SOTT-APIM-Lab</value>
    </set-header>
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}
