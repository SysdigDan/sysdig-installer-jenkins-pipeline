{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.secure_overview_service_token }}{{ end -}}
