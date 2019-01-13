# Request a spot instance at $0.03
data "aws_iam_policy_document" "policy_doc" {
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


resource "aws_iam_role_policy_attachment" "ec2roleforssm-role-policy-attach" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonEC2RoleforSSM.arn}"
}

resource "aws_iam_role" "role" {
  name               = "${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.policy_doc.json}"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.environment}"
  role = "${aws_iam_role.role.name}"
}


resource "aws_iam_role_policy" "policy" {
  name   = "${var.environment}"
  role   = "${aws_iam_role.role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "s3:*",
                "cloudwatch:*",
                "ssm:*",
                "logs:*",
                "sns:*",
                "iam:*",
                "lambda:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_instance" "jemter" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.ssh_key_name}"
  monitoring = true
  subnet_id = "${var.subnetlistprivate[0]}"
  vpc_security_group_ids = ["${var.vpcsecuritygroupid}"]
  iam_instance_profile = "${aws_iam_instance_profile.profile.id}"
  root_block_device {
    volume_size = "${var.root_ebs_size}"
  }


  tags {
    Name = "${var.environment}"
  }
}


resource "null_resource" "exportbucket_name" {
  provisioner "local-exec" {
    command = "export keyprefix='${var.project}'; export bucket='${var.bucket}'"

  }
  depends_on = ["aws_instance.jemter"]
}

output "instance_tag" {
  value = "${aws_instance.jemter.tags.Name}"
}

output "service-role-arn" {
  value = "${aws_iam_role.role.arn}"
}

