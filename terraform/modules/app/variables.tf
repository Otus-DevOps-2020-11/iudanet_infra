variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable subnet_id {
  description = "Subnet"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable "run_provisioner" {
  description = "If true, run provisioner"
  type        = bool
}
variable "db_internal_host" {
  description = "mongo db host"
}
