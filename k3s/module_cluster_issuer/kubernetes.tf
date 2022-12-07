resource "kubernetes_secret" "token" {
  metadata {
    name = "${var.issuer_name}-token"
    namespace = var.namespace
  }

  data = {
    token = vault_token.token.client_token
  }

  type = "Opaque"
}

resource "kubectl_manifest" "issuer" {
  yaml_body = <<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: ${var.issuer_name}
      namespace: cert-manager
    spec:
      vault:
        path: ${var.pki_path}/sign/${var.pki_role}
        server: ${var.vault_connection}
        caBundle: ${base64encode(var.http_ca_cert)}
        auth:
          tokenSecretRef:
              name: ${kubernetes_secret.token.metadata.0.name}
              key: token
  EOT
}
