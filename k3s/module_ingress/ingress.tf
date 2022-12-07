resource "kubectl_manifest" "ingress" {
  yaml_body = <<-EOT
    apiVersion: traefik.containo.us/v1alpha1
    kind: IngressRoute
    metadata:
      name: ${replace("${var.hostname}.${var.domain}", ".", "-")}-ingress
      namespace: ${var.namespace}
    spec:
      entryPoints:
        - web
        - websecure
      routes:
        - match: Host(`${var.hostname}.${var.domain}`)
          kind: Rule
          middlewares:
            - name: secure-redirect
              namespace: default
          services:
            - name: ${var.service_name}
              port: ${var.service_port}
              scheme: ${var.service_scheme}
      tls:
        secretName: ${replace("${var.hostname}.${var.domain}", ".", "-")}-tls
  EOT

  depends_on = [kubectl_manifest.issuer]
}