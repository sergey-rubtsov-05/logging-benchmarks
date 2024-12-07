apiVersion: 1

datasources:
- name: Prometheus
  access: proxy
  type: prometheus
  url: http://${name_prefix}prometheus:9090
  isDefault: true
