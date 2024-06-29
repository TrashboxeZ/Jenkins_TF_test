variable "environment" {
    description = "Environment"
    type = string
    default = null
}

variable "vpc_id" {
    description = "vpc id"
    type = string
    default = ""

}
variable "cidr_ipv4" {
  description = "cidr_ipv4 block from where connects"
  type = string
  default = "0.0.0.0/0"
}

variable "egress_ports" {
  description = "ports for egress rule"
  type = list(string)
  default = []
}

variable "ingress_ports" {
  description = "ports for ingress rule"
  type = list(string)
  default = []
}

variable "egress_protocol" {
  description = "protocol for egress rule"
  type = string
  default = "-1"
}

variable "ingress_protocol" {
  description = "protocol for ingress rule"
  type = string
  default = "-1"
}

variable "self" {
  description = "specify if you need to allow traffic inside group [true|false]"
  type = bool
  default= false
}

locals {
  allow_all_ingress_traffic = length(var.ingress_ports)
  allow_all_egress_traffic = length(var.egress_ports)
}
