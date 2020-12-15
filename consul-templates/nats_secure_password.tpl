{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.nats_secure_password }}{{ end -}}
