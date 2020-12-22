output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}

output "external_ip_address_app_lb" {
  value = {
    for listener in yandex_lb_network_load_balancer.app-balanser.listener :
    listener.name => listener.external_address_spec
  }
}
