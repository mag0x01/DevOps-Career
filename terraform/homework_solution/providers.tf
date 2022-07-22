provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region

  # always use version for provider
  # in this case we are pining the aws provider to version 3.x.x
  # it will take the latest 3.x.x version
  version    = "~> 3.0"
}
