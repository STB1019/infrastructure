resource "kubectl_manifest" "issuer" {
  yaml_body = <<-EOT
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: ${replace("${var.hostname}.${var.domain}", ".", "-")}-crt
      namespace: ${var.namespace}
    spec:
      secretName: ${replace("${var.hostname}.${var.domain}", ".", "-")}-tls
      secretTemplate:
        labels:
          domain: "${var.hostname}.${var.domain}"
      duration: 720h # 30 days
      renewBefore: 360h # 15d
      privateKey:
        algorithm: ECDSA
        encoding: PKCS1
        size: 521
      commonName: ${var.hostname}.${var.domain}
      isCA: false
      usages:
        - server auth
      dnsNames:
        - ${var.hostname}.${var.domain}
        - localhost
      ipAddresses:
        - ${var.machine_ip}
        - 127.0.0.1
      issuerRef:
        name: ${var.issuer_name}
        kind: ClusterIssuer
  EOT
}