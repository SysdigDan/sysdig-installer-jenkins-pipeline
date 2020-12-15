KUBE_NAMESPACE=sysdig
KUSTOMIZE_BUILD_PATH=resources/overlays/${ENVIRONMENT_NAME}
KUSTOMIZATION_RESULT=overlays/kustomize_result.yaml

sysdig-prepare:
	rm -f overlays/place_holder
	mv resources/overlays/${ENVIRONMENT_NAME}/secrets/retrieved/kubeconfig .

sysdig-installer-version:
	chmod +x ./installer
	./installer version

sysdig-installer-generate-base:
	./installer generate --namespace ${KUBE_NAMESPACE} --skip-import --manifest-directory resources/base/installer-generated/

sysdig-installer-generate-deploy:
	./installer generate --namespace ${KUBE_NAMESPACE} --skip-import --manifest-directory resources/deploy/installer-generated/

sysdig-installer-diff-deploy:
	./installer diff --namespace ${KUBE_NAMESPACE} --secure --skip-generate --skip-import --manifest-directory resources/deploy/installer-generated/

sysdig-installer-deploy:
	./installer deploy -n ${KUBE_NAMESPACE} --skip-generate --skip-import --manifest-directory resources/deploy/installer-generated/

sysdig-installer-kustomize:
	cp resources/base/kustomization/kustomization.yaml resources/base/installer-generated/kustomization.yaml
	kustomize build ${KUSTOMIZE_BUILD_PATH} > ${KUSTOMIZATION_RESULT}

get-all:
	kubectl -n ${KUBE_NAMESPACE} get ConfigMap,Deployment,Secret,Service,ServiceAccount,StatefulSet,pvc
	./installer import -n ${KUBE_NAMESPACE} --outfile final_values.yaml

clean-all:
	rm -rf kubeconfig
	rm -rf resources/overlays/sysdig/secrets/retrieved
	rm -rf resources/deploy/installer-generated
	rm -f overlays/kustomization_result.yaml

kubeconfig:
	ENVIRONMENT_NAME=${ENVIRONMENT_NAME} \
	consul-template \
		-vault-addr=${VAULT_ADDR} \
		-vault-renew-token=false \
		-vault-retry-backoff="5s" \
		-vault-retry-attempts=5 \
		-template="consul-templates/kubeconfig.tpl:kubeconfig" \
		-once

SECRETS := $(basename $(notdir $(wildcard consul-templates/*.tpl)))
$(SECRETS): consul-templates/*.tpl
	ENVIRONMENT_NAME=${ENVIRONMENT_NAME} \
	consul-template \
		-vault-renew-token=false \
		-vault-retry-backoff="5s" \
		-vault-retry-attempts=5 \
		-template="consul-templates/$(notdir $@).tpl:resources/overlays/${ENVIRONMENT_NAME}/secrets/retrieved/$@" \
		-once

get-secrets: $(SECRETS)
