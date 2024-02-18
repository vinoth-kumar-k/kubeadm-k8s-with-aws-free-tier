variable "key_name" {
  type    = string
  default = "my-ec2-keypair"
}
variable "region" {
  type    = string
  default = "ap-southeast-1"
}
variable "personal_public_ip" {
  type = string
}