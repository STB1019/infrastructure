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
 - open firewall 4443/tcp 8200/tcp? 53/udp
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

```
export KUBECONFIG=$PWD/config/k3s/kubeconfig.yaml
alias kubectl="kubectl --kubeconfig $KUBECONFIG"

helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik -f k3s/helm/traefik-values.yaml --namespace=kube-system 

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml
```