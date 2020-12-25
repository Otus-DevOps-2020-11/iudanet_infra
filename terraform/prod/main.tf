provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
}

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = var.subnet_id
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = var.subnet_id
}
# resource "yandex_compute_instance" "app" {
#   allow_stopping_for_update = true
#   name                      = "reddit-app-${count.index}"
#   platform_id               = "standard-v2"
#   count                     = var.count_app
#   resources {
#     cores  = 2
#     memory = 2
#   }reddit-db-base-1608923218
#   zone = var.zone_app
#   metadata = {
#     ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
#   }
#   boot_disk {
#     initialize_params {
#       # Указать id образа созданного в предыдущем домашем задании
#       image_id = var.image_id
#     }
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.app-subnet.id
#     nat       = true
#   }

#   provisioner "file" {
#     source      = "files/puma.service"
#     destination = "/tmp/puma.service"
#   }
#   provisioner "remote-exec" {
#     script = "files/deploy.sh"
#   }
#   connection {
#     type  = "ssh"
#     host  = self.network_interface.0.nat_ip_address
#     user  = "ubuntu"
#     agent = false
#     # путь до приватного ключа
#     private_key = file(var.private_key_path)
#   }
# }
# resource "yandex_vpc_network" "app-network" {
#   name = "reddit-app-network"
# }

# resource "yandex_vpc_subnet" "app-subnet" {
#   name           = "reddit-app-subnet"
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.app-network.id
#   v4_cidr_blocks = ["192.168.10.0/24"]
# }
