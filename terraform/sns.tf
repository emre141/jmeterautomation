variable "lambda_arn" {}
resource "aws_sns_topic" "ssm_command_status" {
  name = "${var.environment}-ssm-status"
}

resource "aws_sns_topic_subscription" "ssm_sns_topic_subscribe" {
  topic_arn = "${aws_sns_topic.ssm_command_status.arn}"
  protocol  = "lambda"
  endpoint  = "${var.lambda_arn}"
}

output "aws-sns-topic-arn" {
  value = "${aws_sns_topic.ssm_command_status.arn}"
}