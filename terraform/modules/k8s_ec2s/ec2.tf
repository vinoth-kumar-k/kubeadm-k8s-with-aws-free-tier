data "aws_ami" "ubuntu_22_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*ubuntu-jammy-22.04*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-name"
    values = ["/dev/sda1"]
  }
}

data "cloudinit_config" "user_data_config_control_plane" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/cloud-config.txt")
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/cloud-init.sh", { new_hostname = "controlplane" })
  }
}

data "cloudinit_config" "user_data_config_data_plane_1" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/cloud-config.txt")
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/cloud-init.sh", { new_hostname = "node01" })
  }
}

data "cloudinit_config" "user_data_config_data_plane_2" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/cloud-config.txt")
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/cloud-init.sh", { new_hostname = "node02" })
  }
}

resource "aws_instance" "data_node_1" {
  ami                  = data.aws_ami.ubuntu_22_ami.id
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnet.default_vpc_subnet_2.id
  key_name             = var.key_name # has to be created and downloaded before terraform plan/apply
  security_groups      = [aws_security_group.k8s_nodes_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_node_instance_profile.id
  user_data_base64     = data.cloudinit_config.user_data_config_data_plane_1.rendered
  tags = {
    Name = "node01"
  }
}

resource "aws_instance" "data_node_2" {
  ami                  = data.aws_ami.ubuntu_22_ami.id
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnet.default_vpc_subnet_3.id
  key_name             = var.key_name # has to be created and downloaded before terraform plan/apply
  security_groups      = [aws_security_group.k8s_nodes_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_node_instance_profile.id
  user_data_base64     = data.cloudinit_config.user_data_config_data_plane_2.rendered
  tags = {
    Name = "node02"
  }
}

resource "aws_instance" "master_node" {
  ami                  = data.aws_ami.ubuntu_22_ami.id
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnet.default_vpc_subnet_1.id
  key_name             = var.key_name # has to be created and downloaded before terraform plan/apply
  security_groups      = [aws_security_group.k8s_nodes_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_node_instance_profile.id
  user_data_base64     = data.cloudinit_config.user_data_config_control_plane.rendered
  tags = {
    Name = "control-plane"
  }
}