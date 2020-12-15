{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.anchore_admin_password }}{{ end -}}
