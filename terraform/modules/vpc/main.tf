data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoint = "storage.yandexcloud.net"
    bucket   = "otusdevops2020-tf-backend"
    region   = "us-east-1"
    key      = "1-terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
