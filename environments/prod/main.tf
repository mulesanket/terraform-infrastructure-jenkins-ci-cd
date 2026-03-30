
module "ec2" {
  source = "../../modules/ec2"

  name          = var.name
  env           = var.env
  ami_id        = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default.ids[0]
  key_name      = var.key_name
}