data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_security_group" "vpn" {
  name        = "exercise3-a-sg-vpn"
  description = "WireGuard endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "WireGuard from provider B"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = [var.do_vpn_public_ip]
  }

  egress {
    description = "All outbound (tighten later)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "exercise3-a-sg-vpn"
  }
}

# SSM Session Manager gives shell access without opening port 22
resource "aws_iam_role" "vpn" {
  name = "exercise3-a-vpn-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "vpn_ssm" {
  role       = aws_iam_role.vpn.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "vpn" {
  name = "exercise3-a-vpn-profile"
  role = aws_iam_role.vpn.name
}

resource "aws_instance" "vpn" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.vpn.id]
  iam_instance_profile   = aws_iam_instance_profile.vpn.name
  source_dest_check      = false

  user_data = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y wireguard
    echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-forward.conf
    sysctl --system
  EOT

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "exercise3-a-vpn"
  }
}

resource "aws_eip" "vpn" {
  instance = aws_instance.vpn.id
  domain   = "vpc"

  tags = {
    Name = "exercise3-a-vpn-eip"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block           = var.do_cidr
    network_interface_id = aws_instance.vpn.primary_network_interface_id
  }

  tags = {
    Name = "exercise3-a-rtb-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}