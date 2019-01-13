data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "ssm.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "AmazonEC2RoleforSSM" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


data "template_file" "ssmpolicy" {
  template = "${file((format("%s","terraform/runpolicy.json")))}"

  vars {
    account_id  = "${data.aws_caller_identity.current.account_id}"
    resourcetag = "${var.environment}"
  }
}

resource "aws_iam_policy" "ssm-run-command" {
  name = "${var.environment}-policy"
  policy = "${data.template_file.ssmpolicy.rendered}"
}


resource "aws_iam_role_policy_attachment" "ssm-lifecycle-policy-attachment" {
  policy_arn = "${aws_iam_policy.ssm-run-command.arn}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "ec2roleforssm-role-policy-attachment2" {
  policy_arn = "${data.aws_iam_policy.AmazonEC2RoleforSSM.arn}"
  role = "${aws_iam_role.jmeter_ssm_run.name}"
}

resource "aws_iam_role" "jmeter_ssm_run" {
  assume_role_policy = "${data.aws_iam_policy_document.ssm_lifecycle_trust.json}"
  name = "ssm-${var.environment}"
}


resource "aws_ssm_document" "runshellansible" {
  name          = "ssm-doc-ansible-${var.environment}"
  document_type = "Command"

  content = <<DOC
  {
   "schemaVersion":"2.2",
   "description":"Run Ansible Playbook",
   "mainSteps":[
      {
         "action":"aws:runShellScript",
         "name":"CopyFromS3",
         "precondition":{
            "StringEquals":[
               "platformType",
               "Linux"
            ]
         },
         "inputs":{
            "runCommand":[
               "export AWS_DEFAULT_REGION='${var.aws_region}';export keyprefix='${var.project}'; export bucket='${var.bucket}';aws s3 cp s3://${var.bucket}/ansible /home/ec2-user/ansible.zip;unzip -o /home/ec2-user/ansible.zip -d /opt/jmeter/roles"
            ]
         }
      },
      {
         "action":"aws:runShellScript",
         "name":"RunAnsbile",
         "precondition":{
            "StringEquals":[
               "platformType",
               "Linux"
            ]
         },
         "inputs":{
            "runCommand":[
               "export keyprefix='${var.project}'; export bucket='${var.bucket}';ansible-playbook /opt/jmeter/roles/test.yml --extra-vars='bucket=${var.bucket} keyprefix=${var.project}'"
            ]
         }
      }
   ]
}

DOC
}

output "ssm_doc_name" {
  value = "${aws_ssm_document.runshellansible.name}"
}

output "s3_key_prefix" {
  value = "ssmoutput-${var.project}"
}