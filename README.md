# base_infrastructure

- hashicorp vault
- postgresql
- redis
- nginx

```bash
./terraform base_infrastructure init -upgrade
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve -target=module.vault_deploy
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve -target=module.bind_deploy
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve
docker kill --signal=SIGHUP nginx
cat base_infrastructure/terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'
```