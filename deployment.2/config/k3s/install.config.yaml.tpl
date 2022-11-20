write-kubeconfig-mode: "0600"
write-kubeconfig: ${kubeconfig_dest}

tls-san:
  - "${hostname}"

node-label:
  - "org=${label_org}"

datastore-endpoint: "postgres://${pg_user}@127.0.0.1:5432/${pg_db}"
datastore-cafile: ${ca_file}
datastore-certfile: ${cert_file}
datastore-keyfile: ${key_file}

token: ${cluster_token}

node-name: ieeemaster

data-dir: ${data_dir}

cluster-domain: ${cluster_domain}

secrets-encryption: true

kube-apiserver-arg: 
  - "oidc-username-claim=${oidc_userid_scope}"
  - "oidc-groups-claim=${oidc_kube_scope}"
  - "oidc-ca-file=${oidc_ca_file}"
  - "oidc-issuer-url=${oidc_issue_url}"
  - "oidc-client-id=${oidc_client_id}"
  - "oidc-signing-algs=ES256"