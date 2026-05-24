output "application_url" {
  description = "Deployed Redmine application URL"
  value       = "https://${var.domain_address}"
}

output "vm_admin_username" {
  description = "User for SSH access to application servers"
  value       = var.vm_admin_username
}

output "vm_1_external_ip" {
  description = "External IP address of the first application server"
  value       = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
}

output "vm_2_external_ip" {
  description = "External IP address of the second application server"
  value       = yandex_compute_instance.vm-2.network_interface[0].nat_ip_address
}

output "db_host" {
  description = "PostgreSQL host for Redmine"
  value       = yandex_mdb_postgresql_cluster.devops-3-postgresql-cluster.host[0].fqdn
}

output "db_port" {
  description = "PostgreSQL port for Redmine"
  value       = "6432"
}

output "db_name" {
  description = "PostgreSQL database name for Redmine"
  value       = var.db_name
  sensitive   = true
}

output "db_user" {
  description = "PostgreSQL database user for Redmine"
  value       = var.db_user
  sensitive   = true
}

output "db_password" {
  description = "PostgreSQL database password for Redmine"
  value       = var.db_password
  sensitive   = true
}

output "datadog_api_key" {
  description = "Datadog API key for the Datadog agent"
  value       = var.datadog_api_key
  sensitive   = true
}
