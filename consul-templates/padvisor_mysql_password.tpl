{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.padvisor_mysql_password }}{{ end -}}
