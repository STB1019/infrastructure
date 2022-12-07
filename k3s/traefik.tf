resource "helm_release" "traefik_ingress" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  create_namespace = true
  namespace  = "kube-system"
  wait_for_jobs = true

  values = [
    file("helm/traefik-values.yaml"),
  ]
}

resource "kubectl_manifest" "middleware-redirect" {
  depends_on = [
    helm_release.traefik_ingress
  ]
  yaml_body = <<-EOT
    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
      name: secure-redirect
      namespace: default
    spec:
      redirectScheme:
        scheme: https
        permanent: true
  EOT
}

resource "kubectl_manifest" "middleware-forward-auth" {
  depends_on = [
    helm_release.traefik_ingress
  ]
  yaml_body = <<-EOT
    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
        name: authentik
        namespace: default
    spec:
        forwardAuth:
          address: https://${var.authentik_connection_host}:${var.authentik_connection_port}/outpost.goauthentik.io/auth/traefik
          tls:
            insecureSkipVerify: true
          trustForwardHeader: true
          authResponseHeaders:
              - X-authentik-username
              - X-authentik-groups
              - X-authentik-email
              - X-authentik-name
              - X-authentik-uid
              - X-authentik-jwt
              - X-authentik-meta-jwks
              - X-authentik-meta-outpost
              - X-authentik-meta-provider
              - X-authentik-meta-app
              - X-authentik-meta-version
  EOT
}
