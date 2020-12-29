# data "yandex_iam_service_account" "sa" {
#   service_account_id = var.service_account_id
# }

# // Create Static Access Keys
# resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#   service_account_id = data.yandex_iam_service_account.sa.id
#   description        = "static access key for object storage"
# }

// Use keys to create bucket
resource "yandex_storage_bucket" "tf-backend" {
  access_key = var.static_access_key
  secret_key = var.static_secret_key
  bucket     = "otusdevops2020-tf-backend"
}
