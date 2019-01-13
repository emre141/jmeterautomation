variable "ref_arch_bucket" {
  description = "The bucket name of reference architecture, it starts with 'tf-state-xxxx'"
}
variable "ref_arch_path" {
  description = "The tfstate file where it is stored in reference architecture bucket"
}

variable "policy_name" {
  default = "policy"
}
variable "bucket_name" {
  default = ""
}

variable "project" {}
variable "bucket" {}

variable "instance_type" {}
variable "aws_region" {}
variable "ssh_key_name" {}
variable "root_ebs_size" {}
variable "vpc_cidr" {}
variable "environment" {}
variable "vpcsecuritygroupid" {
  type = "list"
}

## For Cost Tagging
variable "mdsp_are" {}
variable "mdsp_environmet" {}
variable "mdsp_region_datacenter" {}
variable "mdsp_platform_services" {}
variable "mdsp_team" {}
variable "tag_pipelineurl" {}


locals {
  common_tags = {
    MDSP_Area         = "${var.mdsp_are}"
    MDSP_Environment  = "${var.mdsp_environmet}"
    MDSP_Region_Datacenter      = "${var.mdsp_region_datacenter}"
    MDSP_Platform_Services   = "${var.mdsp_platform_services}"
    MDSP_Team = "${var.mdsp_team}"
    PipelineUrl = "${var.tag_pipelineurl}"
  }
}
