# Web outputs
output "node-exporter_private_ips" {
  description = "Private IP addresses of Web VMs"
  value       = module.node-exporter.internal_ips
}

output "node-exporter_ssh" {
  description = "SSH commands to connect to Web VMs"
  value = [
    for ip in module.node-exporter.external_ips : "ssh -l ubuntu ${ip}"
  ]
}

output "prometheus_private_ips" {
  description = "Private IP addresses of Web VMs"
  value       = module.prometheus.internal_ips
}

output "prometheus_ssh" {
  description = "SSH commands to connect to Web VMs"
  value = [
    for ip in module.prometheus.external_ips : "ssh -l ubuntu ${ip}"
  ]
}

output "grafana_private_ips" {
  description = "Private IP addresses of Web VMs"
  value       = module.grafana.internal_ips
}

output "grafana_ssh" {
  description = "SSH commands to connect to Web VMs"
  value = [
    for ip in module.grafana.external_ips : "ssh -l ubuntu ${ip}"
  ]
}