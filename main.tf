################################################################################
# Network Interface
################################################################################

locals {
  nics = {
    for x in var.nics :
    x.name => x
  }
}

resource "ncloud_network_interface" "this" {
  for_each              = local.nics
  name                  = each.value.name
  description           = each.value.description
  subnet_no             = each.value.subnet_no
  access_control_groups = each.value.access_control_groups
}


################################################################################
# Server
################################################################################

resource "ncloud_server" "this" {
  subnet_no                 = var.subnet_no
  name                      = var.name
  server_image_product_code = var.server_image_product_code
  server_product_code       = var.server_product_code
  login_key_name            = var.login_key_name

  dynamic "network_interface" {
    for_each = local.nics

    content {
      network_interface_no = ncloud_network_interface.this[network_interface.value.name].id
      order                = network_interface.value.order
    }
  }

}
