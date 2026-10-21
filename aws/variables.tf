variable "do_cidr" {
  description = "Private network range of the DigitalOcean VPC (provider B)"
  type        = string
  default     = "10.114.0.0/20"
}

variable "do_vpn_public_ip" {
  description = "Public IP of the VPN droplet at provider B, as /32"
  type        = string
  default     = "0.0.0.0/0"
}