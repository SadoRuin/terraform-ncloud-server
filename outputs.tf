output "server_id" {
  description = "서버 ID"
  value       = ncloud_server.this.id
}

output "public_ip" {
  description = "서버 Public IP 주소"
  value       = length(ncloud_public_ip.this) != 0 ? ncloud_public_ip.this[0].public_ip : null
}
