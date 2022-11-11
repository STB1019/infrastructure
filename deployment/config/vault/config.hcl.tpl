storage "raft" {
  path    = "/vault/file"
  node_id = "node1"
}

listener "tcp" {
  address     = "127.0.0.1:${internal_http_port}"
  tls_disable = "true"
}

listener "tcp" {
  address     = "0.0.0.0:${external_https_port}"
  tls_disable = "false"
  tls_key_file = "/etc/vault/server.key"
  tls_cert_file = "/etc/vault/server.fullchain.pem"
}

api_addr = "https://${vault_host}:${external_https_port}"
cluster_addr = "https://127.0.0.1:8201"
ui = true
disable_mlock = true