data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "default_vpc_subnet_1" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "ap-southeast-1a"
}

data "aws_subnet" "default_vpc_subnet_2" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "ap-southeast-1b"
}

data "aws_subnet" "default_vpc_subnet_3" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "ap-southeast-1c"
}