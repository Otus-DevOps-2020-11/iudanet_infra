resource "yandex_compute_instance" "db" {
  name        = "reddit-db"
  platform_id = "standard-v2"
  labels = {
    tags          = "reddit-db"
    ansible_group = "db"
    ansible_name  = "dbserver"

  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

}

resource "null_resource" "app_provisioner" {
  depends_on = [yandex_compute_instance.db]
  count      = var.run_provisioner ? 1 : 0

  provisioner "remote-exec" {
    script = "${path.module}/files/install_mongodb.sh"
  }

  connection {
    type  = "ssh"
    host  = yandex_compute_instance.db.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
}
