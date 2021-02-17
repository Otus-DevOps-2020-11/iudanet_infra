provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
}

resource "yandex_compute_instance" "gitlab-ci" {
  allow_stopping_for_update = true
  name                      = "gitlab-ci-vm"
  platform_id               = "standard-v2"
  resources {
    cores  = 2
    memory = 4
  }
  labels = {
    tags                       = "gitlab-ci"
    ansible_group              = "gitlab-ci_group"
    ansible_name               = "gitlab-ci"
    ansible_host_var_test      = "test"
    ansible_group_var_username = "ubuntu"

  }
  zone = var.zone_app
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = var.image_id
      size     = 50
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}
