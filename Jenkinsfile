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

def installerVersion() {
  sh "make sysdig-installer-version"
}

def installerGenerateBase() {
  sh "make sysdig-installer-generate-base"
}

def installerGenerateDeploy() {
  sh "make sysdig-installer-generate-deploy"
}

def installerDiffDeploy() {
  sh "make sysdig-installer-diff-deploy"
}

def installerDeploy() {
  sh "make sysdig-installer-deploy"
}

def cleanAll() {
  sh "make clean-all"
}

def installerKustomize() {
  sh "make sysdig-installer-kustomize"
}

def getAll() {
  sh "make get-all"
}

pipeline {
  agent {
    docker {
      image 'sysdigdan/kube-tools'
      args '-v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  options {
    timeout(time: 1, unit: 'HOURS')
    timestamps()
  }
  environment {
    HOME = "${WORKSPACE}"
    KUBECONFIG = "${WORKSPACE}/kubeconfig"
    VAULT_ADDR = "http://vault.lab.internal:8200"
  }
  stages {
    stage('Sysdig Installer - Deployment') {
      stages {
        stage('Sysdig Installer - Environment Settings') {
          environment {
            ENVIRONMENT_NAME = "sysdig"
          }
          stages {
            stage('Sysdig Installer - Start') {
              steps {
                sysdig-prepare()
                getSecrets()
                installerVersion()
              }
            }
            stage('Sysdig Installer - Generate Base Manifests') {
              steps {
                installerGenerateBase()
              }
            }
            stage('Sysdig Installer - Kustomize') {
              steps {
                installerKustomize()
              }
            }
            stage('Sysdig Installer - Generate Deployment Manifests') {
              steps {
                installerGenerateDeploy()
              }
            }
            stage('Sysdig Installer - Diff Deployment Manifests') {
              steps {
                installerDiffDeploy()
              }
            }
            stage('Sysdig Installer - Deploy') {
              steps {
                installerDeploy()
                getAll()
              }
            }
            stage('Sysdig Installer - Test Cases') {
              steps {
                echo "TO BE IMPLEMENTED"
              }
            }
          }
          post {
            unsuccessful {
              echo "*******************Sysdig Installer has failed*******************"
              echo "Cleaning up workspace..."
              //cleanAll()
            }
            success {
              echo "*******************Sysdig Installer has was successful*******************"
              echo "Cleaning up workspace..."
              //cleanAll()
            }
          }
        }
      }
    }
  }
  post {
    always {
      echo "Sysdig Installer Finished"
    }
  }
}
