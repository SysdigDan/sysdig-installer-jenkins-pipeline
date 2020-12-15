{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.mysql_root_password }}{{ end -}}
