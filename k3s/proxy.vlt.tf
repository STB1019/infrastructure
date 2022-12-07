resource "kubernetes_namespace" "external-vlt" {
  metadata {
    name = "external-vlt"
  }
}

resource "kubernetes_service" "vlt-proxy" {
  metadata {
    name = "vlt-proxy"
    namespace = kubernetes_namespace.external-vlt.metadata[0].name
  }
  spec {
    type = "ExternalName"
    external_name = var.vault_connection_host
    port{
        name = "https"
        port = var.vault_connection_port
        target_port = var.vault_connection_port
        protocol = "TCP"
    }
  }
}

module vlt_ingress{
    source = "./module_ingress"
    service_name = kubernetes_service.vlt-proxy.metadata[0].name
    service_port = "https"
    service_scheme = "https"
    
    hostname = "vlt"
    domain = var.domain
    machine_ip = var.machine_ip
    machine_cname = var.machine_cname

    namespace = kubernetes_namespace.external-vlt.metadata[0].name
    issuer_name = module.http_issuer.name

}