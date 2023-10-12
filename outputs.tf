output "server_id" {
  description = "서버 ID"
  value       = ncloud_server.this.id
}

output "public_ip" {
  description = "서버 Public IP 주소"
  value       = ncloud_public_ip.this.public_ip
}
