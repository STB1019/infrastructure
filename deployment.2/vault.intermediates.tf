module http_intermediate {
    source = "./module_vault_intermediate"

    pki_name            = "http"
    org                 = data.terraform_remote_state.dep.outputs.org
    root_path           = vault_mount.root.path
    cn                  = "${data.terraform_remote_state.dep.outputs.org} http intermediate ca"
    allowed_domains     = [data.terraform_remote_state.dep.outputs.common_name_domain]
    allowed_uri_sans    = ["*.${data.terraform_remote_state.dep.outputs.common_name_domain}", data.terraform_remote_state.dep.outputs.common_name_domain]
    allow_any_name      = false
    enforce_hostnames   = true
    root_cert_pem       = tls_self_signed_cert.root_ca.cert_pem

    keybits             = 521
}

module postgres_intermediate {
    source = "./module_vault_intermediate"

    pki_name            = "pg"
    org                 = data.terraform_remote_state.dep.outputs.org
    root_path           = vault_mount.root.path
    cn                  = "${data.terraform_remote_state.dep.outputs.org} postgres intermediate ca"
    allowed_domains     = []
    allowed_uri_sans    = ["*"]
    allow_any_name      = true
    enforce_hostnames   = false
    root_cert_pem       = tls_self_signed_cert.root_ca.cert_pem

    keybits             = 521
}



module oidc_intermediate {
    source = "./module_vault_intermediate"

    pki_name            = "oidc"
    org                 = data.terraform_remote_state.dep.outputs.org
    root_path           = vault_mount.root.path
    cn                  = "${data.terraform_remote_state.dep.outputs.org} postgres intermediate ca"
    allowed_domains     = []
    allowed_uri_sans    = ["*"]
    allow_any_name      = true
    enforce_hostnames   = false
    root_cert_pem       = tls_self_signed_cert.root_ca.cert_pem
    keybits             = 521
}
