resource "aws_security_group" "k8s_nodes_sg" {
  name   = "k8s_nodes_sg"
  vpc_id = data.aws_vpc.default_vpc.id

  tags = {
    Name = "k8s_nodes_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_within_vpc" {
  security_group_id = aws_security_group.k8s_nodes_sg.id
  cidr_ipv4         = data.aws_vpc.default_vpc.cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_user_ip" {
  security_group_id = aws_security_group.k8s_nodes_sg.id
  cidr_ipv4         = var.personal_public_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.k8s_nodes_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}