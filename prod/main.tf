
locals {
  web_sg = concat(module.sg-db-self.sg_self_id, module.sg-app.sg_id)

  manager_names = module.web-srv.instance_names
  manager_ips   = module.web-srv.public_ip
  worker_names = module.db-srv.instance_names
  worker_ips   = module.db-srv.public_ip
}

module "web-srv" {
  inst_count           = 2
  source               = "../modules/instance"
  inst_type            = var.inst_type
  inst_name            = var.app_name
  key_name             = var.key_name
  security_group_ids   = local.web_sg
  ami_id               = "ami-007c3072df8eb6584"
  environment          = var.environment
  subnet_ids           = data.terraform_remote_state.network.outputs["${var.environment}-${var.app_sub}-subnet-ids"]
  iam_instance_profile = var.iam_instance_profile
}

module "db-srv" {
  inst_count           = 1
  source               = "../modules/instance"
  inst_type            = var.inst_type
  inst_name            = var.db_name
  key_name             = var.key_name
  security_group_ids   = local.web_sg
  ami_id               = "ami-007c3072df8eb6584"
  environment          = var.environment
  subnet_ids           = data.terraform_remote_state.network.outputs["${var.environment}-${var.app_sub}-subnet-ids"]
  iam_instance_profile = var.iam_instance_profile
}


# module "db-srv" {
#   source             = "../modules/instance"
#   inst_type          = var.inst_type
#   inst_name          = var.db_name
#   key_name           = var.key_name
#   security_group_ids = module.sg-db-self.sg_self_id
#   ami_id             = data.aws_ami.db_ami.id
#   environment        = var.environment
#   subnet_ids         = data.terraform_remote_state.network.outputs["${var.environment}-${var.db_sub}-subnet-ids"]
# }

# resource "aws_ssm_parameter" "db_host_ip" {
#   name        = "MYSQL_HOST_${var.environment}"
#   description = "The parameter description"
#   type        = "String"
#   value       = module.db-srv.private_ip[0]
# }

resource "local_file" "generate_ansible_inventory" {
  content = templatefile("./files/template.tpl", {
    app_names = local.manager_names
    app_ips   = local.manager_ips
    db_names  = local.worker_names
    db_ips    = local.worker_ips
    user      = var.provision_user
  })
  filename = "../../ansible/${var.environment}_hosts"
}
