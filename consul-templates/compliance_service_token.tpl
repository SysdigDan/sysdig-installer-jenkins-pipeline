{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.compliance_service_token }}{{ end -}}
