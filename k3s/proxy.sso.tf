resource "kubernetes_namespace" "external-sso" {
  metadata {
    name = "external-sso"
  }
}

resource "kubernetes_service" "sso-proxy" {
  metadata {
    name = "sso-proxy"
    namespace = kubernetes_namespace.external-sso.metadata[0].name
  }
  spec {
    type = "ExternalName"
    external_name = var.authentik_connection_host
    port{
        name = "https"
        port = var.authentik_connection_port
        target_port = var.authentik_connection_port
        protocol = "TCP"
    }
  }
}

module sso_ingress{
    source = "./module_ingress"
    service_name = kubernetes_service.sso-proxy.metadata[0].name
    service_port = "https"
    service_scheme = "https"
    
    hostname = "sso"
    domain = var.domain
    machine_ip = var.machine_ip
    machine_cname = var.machine_cname

    namespace = kubernetes_namespace.external-sso.metadata[0].name
    issuer_name = module.http_issuer.name

}