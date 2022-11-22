storage "raft" {
  path    = "/vault/file"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:${http_port}"
  tls_disable = "true"
}

api_addr = "https://${vault_domain}:${http_port}"
cluster_addr = "https://127.0.0.1:8201"
ui = true
disable_mlock = true