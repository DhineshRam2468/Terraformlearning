# ─────────────────────────────────────────────────────────────────────────────
# MODULE: VIRTUAL MACHINE  (Week 3)
# for_each over a generated set of VM names
# SSH key generated per VM (no password auth)
# cloud-init: installs nginx on boot
# Joined to LB backend pool via NIC association
# ─────────────────────────────────────────────────────────────────────────────

locals {
  vm_names = toset([for i in range(var.vm_count) : "vm-${var.prefix}-${format("%02d", i + 1)}"])
}

# ── SSH Key pair per VM ───────────────────────────────────────────────────────
resource "tls_private_key" "ssh" {
  for_each  = local.vm_names
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private keys in Key Vault (best practice; requires KV module to run first)
# For training: keys are also written as local files by the script
resource "local_sensitive_file" "ssh_private_key" {
  for_each        = local.vm_names
  content         = tls_private_key.ssh[each.key].private_key_pem
  filename        = "${path.root}/scripts/ssh_keys/${each.key}.pem"
  file_permission = "0600"
}

# ── NICs ─────────────────────────────────────────────────────────────────────
resource "azurerm_network_interface" "this" {
  for_each            = local.vm_names
  name                = "nic-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ── Associate NICs with LB backend pool ──────────────────────────────────────
resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each                = local.vm_names
  network_interface_id    = azurerm_network_interface.this[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.lb_backend_pool_id
}

# ── Linux VMs ─────────────────────────────────────────────────────────────────
resource "azurerm_linux_virtual_machine" "this" {
  for_each            = local.vm_names
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  # cloud-init: install + start nginx on first boot
  custom_data = base64encode(<<-CLOUDINIT
    #cloud-config
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
      - echo "<h1>Hello from ${each.key}</h1>" > /var/www/html/index.html
  CLOUDINIT
  )

  network_interface_ids = [azurerm_network_interface.this[each.key].id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh[each.key].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"   # cheapest tier for free account
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Disable password auth — SSH key only
  disable_password_authentication = true
}
