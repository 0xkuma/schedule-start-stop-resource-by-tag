# resource "aws_s3_bucket" "artifact" {
#   bucket = "schedule-start-stop-resource-by-tag"
#   tags = {
#     Name = "schedule-start-stop-resource-by-tag"
#   }
# }

# resource "aws_s3_bucket_acl" "acl" {
#   bucket = aws_s3_bucket.artifact.id
#   acl    = "private"
# }

resource "aws_s3_object" "lambda_zip" {
  bucket = "eddie-tf-state"
  key    = "schedule-start-stop-resource-by-tag/lambda.zip"
  source = data.archive_file.zip.output_path
}
