receivers:
  filelog:
    include:
    - /var/log/docker/*/*.log
    include_file_path: true

processors:
  batch:

exporters:
  elasticsearch:
    endpoint: http://${name_prefix}elasticsearch:9200
    logs_index: otel-logs
    tls:
      insecure_skip_verify: true

service:
  pipelines:
    logs:
      receivers: [filelog]
      processors: [batch]
      exporters: [elasticsearch]
