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

docker kill --signal=SIGHUP nginx
cat base_infrastructure/terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'
```