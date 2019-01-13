variable "timeout" {
  default = 10
}

variable "sns_topic_arn" {}
variable "module_path" {}
variable "memory_size" {
  default = 128
}
variable "common_tags" {
  type = "map"
}
variable "mdsp_are" {}
variable "mdsp_environmet" {}
variable "mdsp_region_datacenter" {}
variable "mdsp_platform_services" {}
variable "mdsp_team" {}
variable "tag_pipelineurl" {}
variable "environment" {}

variable "handler" {
  default = "triggerdestroy.lambda_handler"
}

variable "runtime" {
  default = "python3.6"
}
variable "subnetlistprivate" {
  type = "list"
}
variable "vpcid" {}
variable "vpc_cidr" {}


resource "aws_security_group" "triggerdestroy_lambda_security_group" {
  name        = "TriggerDestroy-SG"
  description = "Allows ports 443"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = "${merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-TriggerDestroy",
    )
  )}"
}

resource "aws_iam_role" "triggerdestroyrole" {
  name        = "${var.environment}-triggerdestroyrole"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "triggerdestroyrole_policy" {
  name        = "${var.environment}_triggerdestroyrole_policy"
  description = "Allow lambda to access SSM and CloudWatch"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "ec2:Describe*",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:TerminateInstances",
          "ssm:GetParameters",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "rDBLambdaPolicyAttach" {
  role       = "${aws_iam_role.triggerdestroyrole.name}"
  policy_arn = "${aws_iam_policy.triggerdestroyrole_policy.arn}"
}


resource "aws_lambda_function" "triggerdestroy_lambda" {
  function_name    = "${var.environment}-triggerdestroyrole"
  role             = "${aws_iam_role.triggerdestroyrole.arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  filename         = "${var.module_path}/terraform/lambda/triggerdestroy.zip"
  source_code_hash = "${base64sha256(format("%s/terraform/lambda/triggerdestroy.zip", var.module_path))}"
  memory_size      = "${var.memory_size}"
  vpc_config {
    security_group_ids = ["${aws_security_group.triggerdestroy_lambda_security_group.id}"]
    subnet_ids         = ["${var.subnetlistprivate}"]
  }

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "${var.environment}-TriggerDestroy",
    )
  )}"
}

resource "aws_lambda_permission" "triggerdestroy_permission_for_sns" {
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.triggerdestroy_lambda.function_name}"
  principal = "sns.amazonaws.com"
  statement_id = "AllowExecutionFromSNS"
  source_arn = "${var.sns_topic_arn}"
}

output "lambda-arn" {
  value = "${aws_lambda_function.triggerdestroy_lambda.arn}"
}




