receivers:
  filelog:
    include:
    - /var/log/docker/${docker_container_id_to_read_logs_from}/*.log
    include_file_path: true
    operators:
    - type: container
    - type: json_parser

processors:
  batch:

exporters:
  elasticsearch:
    endpoint: ${elasticsearch_endpoint}
    logs_index: otel-logs
    tls:
      insecure_skip_verify: true

service:
  pipelines:
    logs:
      receivers: [filelog]
      processors: [batch]
      exporters: [elasticsearch]
  telemetry:
    logs:
      level: INFO
      encoding: json
