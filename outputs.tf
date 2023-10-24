output "server" {
  description = "서버 출력"
  value       = ncloud_server.this
}

output "network_interfaces" {
  description = "서버 NIC 맵 출력"
  value       = ncloud_network_interface.this
}

output "public_ip" {
  description = "서버 Public IP 주소"
  value       = length(ncloud_public_ip.this) != 0 ? ncloud_public_ip.this[0].public_ip : null
}

output "block_storages" {
  description = "서버 Block Storage 맵 출력"
  value       = ncloud_block_storage.this
}
