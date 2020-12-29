terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "otusdevops2020-tf-backend"
    region                      = "us-east-1"
    key                         = "terraform.tfstate"
    dynamodb_table              = "tf3-lock"
    dynamodb_endpoint           = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gdcd3s8mceq6nifvsb/etn00n5u50914ughdio1"
    skip_region_validation      = true
    skip_credentials_validation = true
    shared_credentials_file     = "~/.aws/credentials"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    access_key                  = var.static_access_key
    secret_key                  = var.static_secret_key
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "otusdevops2020-tf-backend"
    region                      = "us-east-1"
    key                         = "terraform.tfstate"
    dynamodb_table              = "tf3-lock"
    dynamodb_endpoint           = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gdcd3s8mceq6nifvsb/etn00n5u50914ughdio1"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

# create a dynamodb table for locking the state file
