{{- define "generic-scheme-config" -}}
global:
  resolve_timeout: 5m
  slack_api_url: '{{ .alertNoti.slackUrl }}'
route:
  receiver: 'slack-notifications'
  group_by: [ 'alertname' ]
  routes:
    {{- range $rules := .alertNoti.discardRules }}
    - receiver: 'discard'
      match_re:
      {{- toYaml $rules | nindent 8 }}
    {{- end }}
    {{- if .alertNoti.routes }}
    {{- toYaml .alertNoti.routes | nindent 4 }}
    {{- end }}
receivers:
  - name: 'discard'
  - name: 'slack-notifications'
    slack_configs:
    - channel: '{{ .alertNoti.channel }}'
      send_resolved: true
      icon_url: https://avatars3.githubusercontent.com/u/3380462
      title: |-
{{- $files := .Files }}
{{- range tuple "configs/slack-title.yaml" }}
{{ $files.Get . | indent 8 }}
{{- end }}
      text: |-
{{- $files := .Files }}
{{- range tuple "configs/slack-text.yaml" }}
{{ $files.Get . | indent 8 }}
{{- end }}
{{- end -}}