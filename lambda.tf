resource "null_resource" "zipLambda" {
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "cd app/dist && rm -rf * && cp ../*.py . && pip3 install -r ../requirements.txt -t . && zip -r lambda.zip *"
  }
}

resource "aws_lambda_function" "schedule_start_stop_resource" {
  depends_on    = [null_resource.zipLambda]
  function_name = "schedule-start-stop-resource"
  role          = aws_iam_role.labmda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "./app/dist/lambda.zip"
  source_code_hash = filebase64sha256("./app/lambda_function.py")
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