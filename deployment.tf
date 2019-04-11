provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "us-west-2"
  type    = "string"
}

variable "bucket-prefix" {
  default = "braidenc-"
  type    = "string"
}

resource "aws_lambda_function" "project2" {
  function_name    = "dsa"
  handler          = "function.handler"
  runtime          = "python3.7"
  filename         = "app.zip"
  source_code_hash = "${base64sha256(file("app.zip"))}"
  role             = "${aws_iam_role.project2_role.arn}"

  "environment" {
    "variables" {
      OUTPUT_BUCKET = "${aws_s3_bucket.output.bucket}"
    }
  }
}

resource "aws_iam_role_policy" "project2_role_policy" {
  name = "project2_role_policy"
  role = "${aws_iam_role.project2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*"
            ],
            "Resource": "${aws_s3_bucket.output.arn}"
        }
  ]
}
EOF
}

resource "aws_iam_role" "project2_role" {
  name = "project2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "queue" {
  bucket = "${var.bucket-prefix}queue"
  acl    = "private"
}

resource "aws_s3_bucket" "output" {
  bucket = "${var.bucket-prefix}output"
  acl    = "private"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.queue.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.project2.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.project2.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.queue.arn}"
}
