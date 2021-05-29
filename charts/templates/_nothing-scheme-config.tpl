{{- define "nothing-scheme-config" -}}
global:
  resolve_timeout: 5m
route:
  receiver: 'discard'
  group_by: [ 'alertname' ]
receivers:
  - name: 'discard'
{{- end -}}