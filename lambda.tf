resource "null_resource" "zipLambda" {
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "cd app && zip -r lambda.zip *.py "
  }
}

resource "aws_lambda_function" "schedule_start_stop_resource" {
  depends_on    = [null_resource.zipLambda]
  function_name = "schedule-start-stop-resource"
  role          = "arn:aws:iam::066529494542:role/POC-LambdaRole"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "./app/lambda.zip"
  source_code_hash = filebase64sha256("./app/lambda_function.py")
  tags = {
    "Name" = "schedule-start-stop-resource"
  }
}