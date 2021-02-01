resource "yandex_compute_instance" "app" {
  name        = "reddit-app"
  platform_id = "standard-v2"
  labels = {
    tags          = "reddit-app"
    ansible_group = "app"
    ansible_name  = "appserver"

  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
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
  depends_on = [yandex_compute_instance.app]
  count      = var.run_provisioner ? 1 : 0
  provisioner "file" {
    content = templatefile("${path.module}/files/puma.service", {
      DATABASE_URL = "${var.db_internal_host}:27017"
    })
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
  connection {
    type  = "ssh"
    host  = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
}
