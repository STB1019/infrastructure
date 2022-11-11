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

 - cd ../deployment.2
 - terraform init
 - terraform apply -var config_folder=$PWD/../config -var data_folder=$PWD/../data
 - refresh vault https certificates by doing `docker kill --signal="SIGHUP" vault`