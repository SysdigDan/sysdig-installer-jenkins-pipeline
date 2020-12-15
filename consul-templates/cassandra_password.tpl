{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.cassandra_password }}{{ end -}}
