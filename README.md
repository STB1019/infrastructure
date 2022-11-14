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

 - ensure assets directory belongs to user 1000:1000 or that 1000:1000 has read and execute permissions
 - cd ../deployment.2
 - terraform init
 - terraform apply -var config_folder=$PWD/../config -var data_folder=$PWD/../data
 
# After

 - refresh vault https certificates by doing `docker kill --signal="SIGHUP" vault`
 - get akadmin user password: `cat terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'`