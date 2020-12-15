{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.profiling_db_password }}{{ end -}}
