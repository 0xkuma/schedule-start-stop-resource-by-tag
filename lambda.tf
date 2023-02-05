resource "null_resource" "pre_build" {
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "cd ./app/dist && rm -rf * && cp ../*.py . && pip3 install -r ../requirements.txt -t ."
  }
}

resource "aws_lambda_function" "schedule_start_stop_resource" {
  depends_on    = [null_resource.pre_build, data.archive_file.zip]
  function_name = "schedule-start-stop-resource"
  role          = aws_iam_role.labmda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 300
  memory_size   = 2048
  s3_bucket     = "eddie-tf-state"
  s3_key        = aws_s3_object.lambda_zip.key
  source_code_hash = data.archive_file.zip.output_base64sha256
  tags = {
    "Name" = "schedule-start-stop-resource"
  }
}

resource "aws_lambda_permission" "allow_start_event_bridge" {
  statement_id  = "AllowStartResourceSchedule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.schedule_start_stop_resource.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_start_resource_rule.arn
}

resource "aws_lambda_permission" "allow_stop_event_bridge" {
  statement_id  = "AllowStopResourceSchedule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.schedule_start_stop_resource.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_stop_resource_rule.arn
}

data "archive_file" "zip" {
  depends_on  = [null_resource.pre_build]
  type        = "zip"
  source_dir  = "${path.module}/app/dist"
  output_path = "${path.module}/app/dist/lambda.zip"
}

resource "null_resource" "clear_env" {
  depends_on = [aws_s3_object.lambda_zip]
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "rm -rf ${path.module}/app/dist/*"
  }
}