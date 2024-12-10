variable "network_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "user" {
  type    = string
  default = "dbuser"
}

variable "password" {
  type    = string
  default = "dbpassword"
}
