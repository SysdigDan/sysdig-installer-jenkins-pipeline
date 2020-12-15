{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.redis_password }}{{ end -}}
