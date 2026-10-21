output "vpn_public_ip" {
  value = aws_eip.vpn.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.db.address
}