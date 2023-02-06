terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "eddie-terraform"
    key    = "schedule-start-stop-resource-by-tag/terraform-state/terraform.state"
    region = "ap-northeast-1"
  }
}

# provider "aws" {
#   access_key = "${var.AWS_ACCESS_KEY}"
#   secret_key = "${var.AWS_SECRET_KEY}"
#   region     = "${var.AWS_REGION}"
# }
