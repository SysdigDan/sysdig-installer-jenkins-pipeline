{{- with printf "secret/kube-env/lab" | secret }}{{ base64Decode .Data.data.kubeconfig }}{{ end -}}
