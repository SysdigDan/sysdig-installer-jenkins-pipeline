{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.mysql_password }}{{ end -}}
