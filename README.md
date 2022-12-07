# base_infrastructure

- hashicorp vault
- postgresql
- redis
- nginx

```bash
docker build -f terraform.dockerfile -t tetofonta/terraform:latest config

./terraform base_infrastructure init -upgrade

./terraform base_infrastructure apply \
    -var-file=/base_infrastructure/vars.tfvars \
    -target=module.vault_deploy \
    -target=module.bind_deploy \
    -auto-approve 
./terraform base_infrastructure apply \
    -var-file=/base_infrastructure/vars.tfvars \
    -auto-approve
```
 - open firewall 53/udp 6443/tcp 
 - set dns to local#53
 - Finalize authentik configuration
    - get akadmin password with the command `cat base_infrastructure/terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'`
    - login to `https://sso.sb.ieee.elux.ing.unibs.it:4443/`
    - go to **Admin interface**
        - Set Background
            - go to `Flows & Stages > Flows`: For each flow edit and set the background to `/media/bg.png`
        - Set GitHub source
            - From github: `Settings > Developer Settings > OAuth Apps` and create a new app
            - Go to `Directory > Federations & Social Login > edit github` and set the correct client and secret
        - Setup outpost redirect
            - go to `Applications > outposts` and edit the only one with the correct values and add the applications to the outpost
 - Install helm and kubectl on the computer
 - install k3s using `config/k3s/install.yaml` config file: `curl -sfL https://get.k3s.io | sh -s - --config "$PWD/config/k3s/install.yaml"`
 - Clone `kubeconfig.yaml` to your local machine and set remote server. (Located in `$PWD/config/k3s/kubeconfig.yaml`)

## On your local machine

```
cd k3s
terraform init

export KUBECONFIG=$PWD/config/k3s/kubeconfig.yaml
alias kubectl="kubectl --kubeconfig $KUBECONFIG"

helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik -f k3s/helm/traefik-values.yaml --namespace=kube-system 

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml
```


### example base_infrastructure/vars.tfvars
```
domain = "ieee.elux.ing.unibs.it"
host_cname = "ieee.elux.ing.unibs.it"
subdomain = "sb."
app_subdomain = "app."

vault_host = "vlt"
authentik_host = "sso"
pg_host = "sql"
traeffik_dashboard_dns = "httpdashboard"

user = "1000:1000"
user_id = "1000"
machine_ip = "192.168.1.174"

vault_key_shares = 1
vault_key_threshold = 1

org = "ieeesb1019"
locality = "UniBS"
province = "Brescia"
nation = "Italy"

acl_network = "192.168.1.0/24"
```
### example k3s/vars.tfvars
```
domain = "sb.ieee.elux.ing.unibs.it"

remote_machine_ip = "192.168.1.174"
kubeconfig_location = "../config/k3s/kubeconfig.yaml"

vault_connection_host = "192.168.1.174"
vault_connection_port = 8200

vault_token = "hvs.bsjTbq9ighijtYraqjUFRc46"

authentik_connection_host = "192.168.1.174"
authentik_connection_port = 4443
authentik_token = "J)TYkypFAd8js9KuG9vo@_b$l6_eFZ@qQ^99^^jNC\u0026LW)p%-hD6ZdsjEK_$dyKJ@z(WnAs(e(ynKiwP@GzyU*@YcK$GbY8R=I_T^32LhQEK%AwWgG\u0026M_Ore7Ge1jsNP_"

machine_ip = "192.168.1.174"
machine_cname = "ieee.elux.ing.unibs.it"

tsig_secret = "ww/WPMqqUhyFsbMUwr6lnnG4I0+jmh7omWWISQI0u1E="
tsig_keyname = "dyn.sb.ieee.elux.ing.unibs.it."
tsig_algo = "hmac-sha256"
dns_server = "127.0.0.1"
dns_port = 53
```
