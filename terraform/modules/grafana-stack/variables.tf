variable "network_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "prometheus_targets" {
  type    = list(object({
    job_name        = string
    scrape_interval = optional(string, "15s")
    targets         = list(string)
  }))
  default = []
}
