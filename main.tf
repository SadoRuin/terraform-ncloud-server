################################################################################
# Network Interface
################################################################################

locals {
  network_interfaces = {
    for x in var.network_interfaces :
    x.order => x
  }
}

resource "ncloud_network_interface" "this" {
  for_each = local.network_interfaces

  name                  = each.value.name
  description           = each.value.description
  private_ip            = each.value.private_ip
  subnet_no             = each.value.subnet_id
  access_control_groups = each.value.access_control_groups
}


################################################################################
# Server
################################################################################

resource "ncloud_server" "this" {
  name      = var.name
  subnet_no = var.subnet_id

  server_image_product_code = (
    var.server_image_name != null
    ? data.ncloud_server_image.server_image[0].id
    : null
  )

  member_server_image_no = (
    var.member_server_image_name != null
    ? data.ncloud_member_server_image.member_server_image[0].id
    : null
  )

  server_product_code  = data.ncloud_server_product.server_product.id
  login_key_name       = var.login_key_name
  fee_system_type_code = var.fee_system_type_code
  init_script_no       = var.init_script_no

  is_protect_server_termination          = var.is_protect_server_termination
  is_encrypted_base_block_storage_volume = var.is_encrypted_base_block_storage_volume

  dynamic "network_interface" {
    for_each = local.network_interfaces

    content {
      network_interface_no = ncloud_network_interface.this[network_interface.key].id
      order                = network_interface.key
    }
  }
}


################################################################################
# Server Image
################################################################################

data "ncloud_server_image" "server_image" {
  count = var.server_image_name != null ? 1 : 0

  filter {
    name   = "product_name"
    values = [var.server_image_name]
  }
}

data "ncloud_member_server_image" "member_server_image" {
  count = var.member_server_image_name != null ? 1 : 0

  filter {
    name   = "name"
    values = [var.member_server_image_name]
  }
}


################################################################################
# Server Product
################################################################################

locals {
  product_type = {
    "High CPU"      = "HICPU"
    "Standard"      = "STAND"
    "High Memory"   = "HIMEM"
    "CPU Intensive" = "CPU"
    "GPU"           = "GPU"
    "BareMetal"     = "BM"
  }
}

data "ncloud_server_product" "server_product" {
  server_image_product_code = (
    var.server_image_name != null
    ? data.ncloud_server_image.server_image[0].id
    : data.ncloud_member_server_image.member_server_image[0].original_server_image_product_code
  )

  filter {
    name   = "generation_code"
    values = [upper(var.product_generation)]
  }
  filter {
    name   = "product_type"
    values = [local.product_type[var.product_type]]
  }
  filter {
    name   = "product_name"
    values = [var.product_name]
  }
}

################################################################################
# Public IP
################################################################################

resource "ncloud_public_ip" "this" {
  count              = var.is_associate_public_ip ? 1 : 0
  server_instance_no = ncloud_server.this.id
}


################################################################################
# Block Storage
################################################################################

locals {
  block_storages = {
    for x in var.additional_block_storages :
    x.name => x
  }
}

resource "ncloud_block_storage" "this" {
  for_each = local.block_storages

  server_instance_no             = ncloud_server.this.id
  name                           = each.value.name
  description                    = each.value.description
  size                           = each.value.size
  disk_detail_type               = each.value.disk_detail_type
  stop_instance_before_detaching = each.value.stop_instance_before_detaching
}
