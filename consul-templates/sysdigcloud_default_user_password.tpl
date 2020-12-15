{{- with printf "secret/sysdig/sysdig" | secret }}{{ base64Decode .Data.data.sysdigcloud_default_user_password }}{{ end -}}
