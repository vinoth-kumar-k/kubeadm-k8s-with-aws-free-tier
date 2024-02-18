module "kubeadm_k8s_ec2s" {
  source             = "../../modules/k8s_ec2s"
  personal_public_ip = var.personal_public_ip
}