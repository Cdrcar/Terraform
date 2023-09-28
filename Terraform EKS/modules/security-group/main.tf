resource "aws_security_group" "security-group" {
  name        = "vpc-security-group"
  description = "security group for load balancer"
  vpc_id      = var.vpc_id
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
      description = "postgress"
       from_port = 5432
       to_port        = 5432
       protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
    }
     
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #   tags = {
  #     Name      = var.name-security-group
  #     managedby = var.managedby
  #   }
}

# # Allow SSH access from specified IP address
# resource "aws_security_group_rule" "ssh_ingress" {
#   type = "ingress"
#   from_port = 22
#   to_port = 22
#   protocol = "tcp"
#   cidr_blocks = [var.ssh_cidr_block]

#   security_group_id = aws_security_group.security-group.id

#   description = "Allow SSH access from specified IP address"

#   # Only create rule if ssh_cidr_block is not 0.0.0.0/0
#   count = var.ssh_cidr_block != "0.0.0.0/0" ? 1 : 0
# }
