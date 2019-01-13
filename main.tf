provider "aws" {
  region     = "${var.aws_region}"
}

provider "archive" {
  version = "~> 1.0"
}


terraform {
  backend "s3" {}
}

resource "null_resource" "set_path" {
  triggers = {
    path_module = "${path.module}"
  }
}

data "terraform_remote_state" "reference_arch" {
  backend = "s3"

  config {
    bucket = "${var.ref_arch_bucket}"
    key    = "${var.ref_arch_path}"
    region = "${var.aws_region}"
  }
}

data "aws_ami" "jmeterami" {
  most_recent      = true
  owners = ["850526132661"]
  filter {
    name   = "tag:Name"
    values = ["JMeterAMI"]
  }
}

module "jmeter" {
  source = "terraform"
  ami = "${data.aws_ami.jmeterami.image_id}"
  instance_type = "${var.instance_type}"
  vpcid                                  = "${data.terraform_remote_state.reference_arch.vpc_id}"
  subnetlistprivate                      = ["${data.terraform_remote_state.reference_arch.priv-subnets}"]
  common_tags                            = "${local.common_tags}"
  mdsp_are                               = "${var.mdsp_are}"
  mdsp_environmet                        = "${var.mdsp_environmet}"
  mdsp_region_datacenter                 = "${var.mdsp_region_datacenter}"
  mdsp_platform_services                 = "${var.mdsp_platform_services}"
  mdsp_team                              = "${var.mdsp_team}"
  tag_pipelineurl                        = "${var.tag_pipelineurl}"
  ssh_key_name                           = "${var.ssh_key_name}"
  root_ebs_size                          = "${var.root_ebs_size}"
  vpc_cidr                               = "${var.vpc_cidr}"
  vpcsecuritygroupid                     = "${var.vpcsecuritygroupid}"
  environment                            = "${var.environment}"
  aws_region                             = "${var.aws_region}"
  project                                = "${var.project}"
  bucket                                 = "${var.bucket}"
  module_path                            = "${null_resource.set_path.triggers.path_module}"
  lambda_arn                             = "${module.lambda.lambda-arn}"
}

module "lambda" {
  source = "terraform/lambda"
  sns_topic_arn                          = "${module.jmeter.aws-sns-topic-arn}"
  common_tags                            = "${local.common_tags}"
  mdsp_are                               = "${var.mdsp_are}"
  mdsp_environmet                        = "${var.mdsp_environmet}"
  mdsp_region_datacenter                 = "${var.mdsp_region_datacenter}"
  mdsp_platform_services                 = "${var.mdsp_platform_services}"
  mdsp_team                              = "${var.mdsp_team}"
  tag_pipelineurl                        = "${var.tag_pipelineurl}"
  vpc_cidr                               = "${var.vpc_cidr}"
  module_path                            = "${null_resource.set_path.triggers.path_module}"
  environment                            = "${var.environment}"
  vpcid                                  = "${data.terraform_remote_state.reference_arch.vpc_id}"
  subnetlistprivate                      = ["${data.terraform_remote_state.reference_arch.priv-subnets}"]
}
output "bucket_name" {
  value = "${module.jmeter.bucket_name_list}"
}

output "ssm_doc_name" {
  value = "${module.jmeter.ssm_doc_name}"
}

output "s3_key_prefix" {
  value = "${module.jmeter.s3_key_prefix}"
}

output "instance_tag" {
  value = "${module.jmeter.instance_tag}"
}

output "service_role_arn" {
  value = "${module.jmeter.service-role-arn}"
}

output "aws_sns_topic_arn" {
  value = "${module.jmeter.aws-sns-topic-arn}"
}

output "lambda_arn" {
  value = "${module.lambda.lambda-arn}"
}