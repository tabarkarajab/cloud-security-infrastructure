variable "do_cidr" {
  description = "Private network range of the DigitalOcean VPC (provider B)"
  type        = string
  default     = "10.20.0.0/24"
}

variable "do_vpn_public_ip" {
  description = "Public IP of the VPN droplet at provider B, as /32"
  type        = string
  default     = "207.154.238.161/32"
}

variable "db_password" {
  description = "Master password of the PostgreSQL database (set via TF_VAR_db_password secret)"
  type        = string
  sensitive   = true
}