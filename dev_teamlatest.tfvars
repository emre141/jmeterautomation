ref_arch_bucket = "<reference_remote_state_bucket>"
ref_arch_path = "<referece_remote_state_terraform_file>"
vpc_cidr = "<vpc_cidr>"

#I have used packer build in my vpc so there is needed to ssh access during packer ami build
vpcsecuritygroupid = ["<security_group_for_creating_ami>"]

environment = "jmeter"


#The result of the test have been sending to the bucket
bucket = "<bucket_name>"
#The result of the test have been sending to the folder under bucket
project = "<folder>"

root_ebs_size = 20
ssh_key_name = "jmeter"
aws_region =  "eu-central-1"
#instance_type = "m5.12xlarge"
instance_type = "m5.12xlarge"
##### Cost Tagging ##########

mdsp_are = "<area>"
mdsp_environmet = "<environment>"
mdsp_region_datacenter = "<region>"
mdsp_platform_services= "<platform>"
mdsp_team = "<team>"
tag_pipelineurl = "<pipeline_url>"