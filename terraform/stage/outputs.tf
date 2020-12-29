output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}

output "db_internal_host" {
  value = module.db.db_internal_host

}
# output "external_ip_address_app_lb" {
#   value = {
#     for listener in yandex_lb_network_load_balancer.app-balanser.listener :
#     listener.name => listener.external_address_spec
#   }
# }
