variable "ami" {}
variable "instance_type" {}
variable "ssh_key_name" {}
variable "root_ebs_size" {}
variable "vpcid" {}
variable "vpc_cidr" {}
variable "aws_region" {}
variable "bucket" {}
variable "module_path" {}
variable "vpcsecuritygroupid" {
  type = "list"
}
variable "subnetlistprivate" {
  type = "list"
}

variable "project" {}
variable "environment" {}


variable "policy_name" {
  default = "policy"
}
variable "bucket_name" {
  default = ""
}

### For Tagging
variable "tag_pipelineurl" {}
variable "mdsp_are" {}
variable "mdsp_environmet" {}
variable "mdsp_region_datacenter"{}
variable "mdsp_platform_services" {}
variable "mdsp_team" {}
variable "common_tags" {
  type = "map"
}


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