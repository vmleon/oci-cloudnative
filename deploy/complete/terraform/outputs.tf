# Copyright (c) 2020, 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "mushop_url_button" {
  value       = format("http://%s", local.mushop_ingress_ip)
  description = "MuShop Storefront URL for ORM button"

  depends_on = [helm_release.ingress_nginx]
}
output "mushop_url" {
  value       = format("http://%s", local.mushop_ingress_ip)
  description = "MuShop Storefront URL"

  depends_on = [helm_release.ingress_nginx]
}
output "mushop_url_https" {
  value       = format("https://%s", local.mushop_ingress_hostname)
  description = "MuShop Storefront Hostname"

  depends_on = [helm_release.ingress_nginx]
}
output "grafana_url" {
  value       = format("http://%s/grafana", local.mushop_ingress_ip)
  description = "Grafana Dashboards URL"

  depends_on = [helm_release.ingress_nginx]
}
output "external_ip" {
  value = local.mushop_ingress_ip

  depends_on = [helm_release.ingress_nginx]
}
output "autonomous_database_password" {
  value     = random_string.autonomous_database_admin_password.result
  sensitive = false
}
output "grafana_admin_password" {
  value     = data.kubernetes_secret.mushop_utils_grafana.data.admin-password
  sensitive = false
}
### Important Security Notice ###
# The private key generated by this resource will be stored unencrypted in your Terraform state file. 
# Use of this resource for production deployments is not recommended. 
# Instead, generate a private key file outside of Terraform and distribute it securely to the system where Terraform will be run.
output "generated_private_key_pem" {
  value = var.generate_public_ssh_key ? tls_private_key.oke_worker_node_ssh_key.private_key_pem : "No Keys Auto Generated"
}
output "dev" {
  value = "Made with \u2764 by Oracle Developers"
}
output "comments" {
  value = "The application URL will be unavailable for a few minutes after provisioning, while the application is configured"
}
output "deploy_id" {
  value = random_string.deploy_id.result
}
output "kubeconfig_for_kubectl" {
  value       = "export KUBECONFIG=./generated/kubeconfig"
  description = "If using Terraform locally, this command set KUBECONFIG environment variable to run kubectl locally"
}
output "mushop_source_code" {
  value = "https://github.com/oracle-quickstart/oci-cloudnative/tree/master/deploy/complete"
}
locals {
  mushop_ingress_ip       = data.kubernetes_service.mushop_ingress.status.0.load_balancer.0.ingress.0.ip
  mushop_ingress_hostname = data.kubernetes_service.mushop_ingress.status.0.load_balancer.0.ingress.0.hostname == "" ? data.kubernetes_service.mushop_ingress.status.0.load_balancer.0.ingress.0.ip : data.kubernetes_service.mushop_ingress.status.0.load_balancer.0.ingress.0.hostname
}