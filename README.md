# base_infrastructure

- hashicorp vault
- postgresql
- redis
- nginx

```
./terraform base_infrastructure init -upgrade
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve -target=module.vault_deploy
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve -target=module.bind_deploy
./terraform base_infrastructure apply -var-file=/base_infrastructure/vars.tfvars -auto-approve
```