resource "yandex_lb_target_group" "app-target-group" {
  name = "app-target-group-id"

  dynamic "target" {
    for_each = yandex_compute_instance.app
    content {
      subnet_id = var.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "app-balanser" {
  name = "app-load-balancer"

  listener {
    name        = "my-listener"
    port        = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.app-target-group.id

    healthcheck {
      name = "tcp"
      tcp_options {
        port = 9292
      }
    }
  }
}
