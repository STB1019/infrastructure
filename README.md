# Before
Prepare for installation. Install docker, jq, terraform.

## Configure Docker user permissions

In order to be able to access docker without root you need the current user to be inside docker group
```bash
usermod -aG docker $(whoami)
```
After that, you'll need to start a new shell in order for the modification to be loaded.

<!--## Configure Docker logging 

Docker logs everything an application outputs.
That can cause disk usage problems after a while.

Configure docker to log as json-file limiting the file sizes and number of maintained instances before rotation.

1) Edit `/etc/docker/daemon.json` and add this directives in the root object.

```json
{
  "metrics-addr" : "127.0.0.1:9323",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "256m",
    "max-file": "4",
    "compress": "true"
  }
}
```

As presented logs will occupy a maximum of 1024MB in 4 files in a compressed format.-->

# Deployment 1

First deployment will prepare the system and will deploy an un-configured vault instance.
This instance will listen on port 8233/tcp - https with a self signed certificate.

Edit the file `deployment/vars.tf` and then run the following
```bash
cd deployment
terraform init
terraform apply -var config_folder=$PWD/../config -var data_folder=$PWD/../data
```

When `module.wait_vault.data.external.wait: Still reading...` appears, init vault and get the unseal keys and the root token from the web interface.

# Deployment 2

The second deploy will configure authentik as an identity provider.
It will deploy a postgresql instance with mutual tls authentication, a redis instance with password authentication and authentik itself with some personalizations.

Current authentik policies are:
 - In order for a user enrolling himself with a github account his presence in the organization [STB1019](https://github.com/STB1019). _edit the file `deployment.2/policies/github-orgs.py` for changes in this policy_
 - External user can enroll only with an invitation generated by an admin user or a member of the **executive** group.
 - After enrollment, a user must select a committee by using the available link in his/her homepage.

## Get OAUTH credentials

On github go into `your gh profile > settings > developer settings > oauth apps > create oauth app`
 - Copy client secret
 - Copy client id
 - Insert as callback url the following: `https://<deployment.2/authentik.vars.tf - authentik_subdomain><deployment/vars.tf - common_name_domain>[:8443 if not behind a reverse proxy]/source/oauth/callback/github/`


## Deploying

Edit files `deployment.2/vars.tf`, `deployment.2/authentik.vars.tf`

```bash
cd ..
chown -R 1000:1000 assets
cd ../deployment.2

VAULT_TOKEN="<previously generated token>"
GH_CID="<previously generated gh client id>"
GH_CS="<previously generated gh client id>"
cat << EOF > vars.tfvars
config_folder="${PWD}/../config" 
data_folder="${PWD}/../data"
vault_token="${VAULT_TOKEN}"
gh_client_id="${GH_CID}"
gh_secret="${GH_CS}"
EOF
terraform init
terraform apply -var-file=vars.tfvars
```
 
## After
 - refresh vault https certificates by doing `docker kill --signal="SIGHUP" vault`
 - get akadmin user password: `cat terraform.tfstate | jq -r '.resources[] | select( .name == "akadmin_password" ) | .instances[0].attributes.result'`
 - Go to authentik and set the new tenant as default. You can now remove authentik-default tenant
 - Verify that Authentik uses our custom certificate


# Deployment 3

Install kubernetes (k3s) by using the generated `install.config.yaml` from deployment.2
with the following command and deploy the third part of the deployment

```bash
curl -sfL https://get.k3s.io | sh -s - --config "${PWD}/config/k3s/install.config.k3s"
cd deployment.3
cat << EOF > vars.tfvars
config_folder="${PWD}/../config" 
data_folder="${PWD}/../data"
vault_token="${VAULT_TOKEN}"
authentik_token="${AUTHENTIK_TOKEN}"
EOF
terraform init
terraform apply -var-file=vars.tfvars
```


