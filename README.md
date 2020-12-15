# Jenkins Pipeline for Sysdig Installer

This is a jenkins pipeline for Sysdig Backend deployment/upgrades. It includes the following:
- Uses the Sysdig Installer Binary for >3.5.0 installation and upgrades.
- Use kustomize to further modify the Sysdig Installation/Upgrade, including retreival of secrets from vault.

## Getting Started

In order to use the pipeline, you will first need to complete the following -

1. Obtainer the Sysdig Installer from Sysdig Support and place in the root of the repository.
2. Follow the Sysdig Documentation to customize the deployment - https://docs.sysdig.com/en/installer--kubernetes---openshift-.html#idp125657

## Jenkins and Vault Setup

In order to integrate the pipeline with jenkins you will need to install and configure the HashiCorp Vault Plugin - https://plugins.jenkins.io/hashicorp-vault-plugin/

The provided Jenkinsfile can be used to retireve passwords and secrets from vault using the provided function getSecrets(). The function will retrieve the stored kubeconfig and Sysdig passwords and secrets from Vault.
```
def getSecrets() {
  withCredentials([
          [
              $class: 'VaultTokenCredentialBinding',
              credentialsId: 'vault-cred',
              vaultAddr: "$VAULT_ADDR"
          ]
      ])
          {
              sh "make --always-make kubeconfig"
              sh "make --always-make get-secrets"
          }
}
```

In order to retrieve secrets and passwords stored in vault we use consul templates. These templates need to be adjusted based on how you have configured your vault paths.


The provided Jenkinsfile uses stored credentials for vault and defines the vault address in an environment variable which will need to be modified.
```
  environment {
    HOME = "${WORKSPACE}"
    KUBECONFIG = "${WORKSPACE}/kubeconfig"
    VAULT_ADDR = "http://vault.lab.internal:8200"
  }
```

## Vault Secrets and Passwords
The below is an example of how to configure vault for the provided Jenkins pipeline.

### Create the Sysdig KV in Vault
```
vault secrets enable -version=2 -path="secret/sysdig" kv
```

### Create the Sysdig Secrets and Passwords
Note - You will need to add secrets that have been encode for each of the keys below - https://www.base64decode.org/
```
vault kv put secret/sysdig/sysdig \
anchore_admin_password= \
anchore_db_password= \
padvisor_mysql_password= \
profiling_db_password= \
scanning_mysql_password= \
mysql_password= \
mysql_root_password= \
cassandra_password= \
redis_password= \
nats_secure_password= \
smtp_password= \
sysdigcloud_default_user_password= \
sysdig_license= \
scanning_service_token= \
secure_overview_service_token= \
compliance_service_token= \
events_service_token= \
sysdigcloud_ldap_manager_password=
```

### Create the kubeconfig file
```
vault kv put secret/kube-env/lab \
kubeconfig=
```

## Give Jenkins acess to Vault

#### Enable the approle backend
```
vault auth enable approle
```

#### Write the jenkins app policy
```
# Read-only permission on 'secret/sysdig/*' path
path "secret/sysdig/*" {
  capabilities = [ "read" ]
}
# Read-only permission on 'secret/kube-env/*' path
path "secret/kube-env/*" {
  capabilities = [ "read" ]
}
```

#### Create the approle for Jenkins
```
vault write auth/approle/role/jenkins \
token_ttl=1h \
token_max_ttl=4h \
token_policies=jenkins
```
