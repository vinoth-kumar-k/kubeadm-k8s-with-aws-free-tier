resource "aws_iam_instance_profile" "k8s_node_instance_profile" {
  name = "k8s_node_instance_profile"
  role = aws_iam_role.k8s_node_role.name
}

data "aws_iam_policy_document" "k8s_node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "k8s_node_role" {
  name                = "k8s_node_role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.k8s_node_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}