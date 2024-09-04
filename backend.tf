terraform {
  backend "s3" {
    bucket         = "tf-infra-task1"
    key            = "terraform/state"
    region         = "us-east-1"
  }
}
