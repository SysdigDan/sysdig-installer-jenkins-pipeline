{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.sysdig_license }}{{ end -}}
