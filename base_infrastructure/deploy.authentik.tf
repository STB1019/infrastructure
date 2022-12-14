module authentik_deploy{
    source = "./module_authentik_deploy"
    
    pg_backend = module.pg_ca.backend
    client_backend = module.pg_ca.client_role
    assets_dir = var.assets_dir
    blueprints_dir = var.blueprints_dir
    postgres_host = module.postgres_deploy.container_name

    network_name = var.network_name
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    user = var.user
    depends_on = [
      module.postgres_deploy
    ]
}

module "authentik_provision"{
  source = "./module_authentik_provision"
  http_backend = module.http_ca.backend
  client_backend = module.http_ca.server_role
  domain = "${var.subdomain}${var.domain}"
  vault_container_name = module.vault_deploy.container_name

  depends_on = [
    module.authentik_deploy,
    module.vault_deploy
  ]
}