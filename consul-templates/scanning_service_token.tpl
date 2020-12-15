{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.scanning_service_token }}{{ end -}}
