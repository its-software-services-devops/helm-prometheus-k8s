{{- define "default-scheme-config" -}}
global:
  resolve_timeout: 5m
  slack_api_url: '{{ .alertNoti.slackUrl }}'
route:
  receiver: 'slack-notifications'
  group_by: [ 'alertname' ]
  routes:
    {{- if eq .alertNoti.discardByAlertName "true" }}
    - receiver: 'discard'
      match_re:
        alertname: '{{ .alertNoti.discardAlertName }}'
    {{- end }}
    {{- if eq .alertNoti.discardBySeverityName "true" }}
    - receiver: 'discard'
      match_re:
        severity: '{{ .alertNoti.discardSeverityName }}'
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