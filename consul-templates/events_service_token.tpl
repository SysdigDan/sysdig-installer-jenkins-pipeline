{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.events_service_token }}{{ end -}}
