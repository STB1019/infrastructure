# First steps

 - install docker, jq, terraform
 - configure docker log engine 

# Deployment 1

 - cd deployment
 - terraform init
 - terraform apply -var config_folder=$PWD/../config -var data_folder=$PWD/../data

Hashicorp vault will be up at https://--your--IP--:8233/
When `module.wait_vault.data.external.wait: Still reading...` appears, init vault and get the unseal keys and the root token from the web interface
Unseal the vault

# Deployment 2

get github application auth capabilities by going into `your gh profile > settings > developer settings > oauth apps > create oauth app`
 - copy client secret
 - copy client id
insert as callback url the following: `https://<authentik host>:8443/source/oauth/callback/github/`

 - ensure assets directory belongs to user 1000:1000 or that 1000:1000 has read and execution permissions
 - cd ../deployment.2
 - 
 ```
cat << EOF > vars.tfvars
config_folder="$PWD/../config" 
data_folder="$PWD/../data"
vault_token="_token_"
gh_client_id="_clientid_"
gh_secret="_secret_"
EOF
```
 - terraform init
 - terraform apply -var-file=vars.tfvars
 
# After

 - refresh vault https certificates by doing `docker kill --signal="SIGHUP" vault`
 - get akadmin user password: `cat terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'`