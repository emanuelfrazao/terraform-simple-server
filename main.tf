
resource "aws_security_group" "sg" { #uses default vpc
  name = "base-security-group"

  tags = {
    Name = "base-security-group"
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ipv4]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = local.ssh_port
  to_port     = local.ssh_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ipv4]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.sg.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = [local.all_ipv4]
}

resource "aws_key_pair" "deployer" {
    key_name   = "demo-terraform"
    public_key = file("~/.ssh/aws.pub")
}

resource "aws_instance" "base" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World!" > index.html
                nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "base-instance"
  }
}

output "public_ip" {
  value = aws_instance.base.public_ip
}

output "instance_id" {
  value = aws_instance.base.id
}