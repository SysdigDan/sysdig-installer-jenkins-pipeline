{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.smtp_password }}{{ end -}}
