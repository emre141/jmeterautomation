resource "aws_s3_bucket" "s3_bucket" {
  bucket      = "${var.bucket}"
  acl         = "private"
  #force_destroy = true

  versioning {
    enabled = "false"
  }
  lifecycle_rule {
    enabled = "false"

    expiration {
      days = 3
    }
  }
  tags = "${merge(
    var.common_tags,
    map(
      "Name", "${var.environment}",
    )
  )}"

}

resource "null_resource" "set_path" {
  triggers = {
    path_module = "${path.module}"
  }
}

data "archive_file" "archive_ansible" {
  source_dir = "${path.module}/roles/"
  output_path = "${format("%s%s","${var.environment}",".zip")}"
  type = "zip"
  depends_on = ["aws_s3_bucket.s3_bucket"]
}


resource "aws_s3_bucket_object" "ansibledirectory" {
  bucket = "${var.bucket}"
  key =    "ansible"
  source = "${data.archive_file.archive_ansible.output_path}"
  etag = "${data.archive_file.archive_ansible.output_md5}"
}

output "bucket_arn_list" {
  value = ["${aws_s3_bucket.s3_bucket.*.arn}"]
}

output "bucket_name_list" {
  value = ["${aws_s3_bucket.s3_bucket.*.bucket}"]
}



