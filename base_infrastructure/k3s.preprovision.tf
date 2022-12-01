module k3s_preprovision{
    source = "./module_k3s_preprovision"

    domain = var.domain
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    machine_ip = var.machine_ip
    org = var.org
    pg_backend = module.pg_ca.backend
    client_backend = module.pg_ca.client_role
    oidc_backend = module.oidc_ca.backend
    oidc_client_backend = module.oidc_ca.server_role
    http_ca_pem = module.http_ca.bundle
    sso_domain = "${var.authentik_host}.${var.subdomain}${var.domain}"

    depends_on = [
      module.authentik_provision
    ]
}