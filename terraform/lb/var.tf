variable "env" {
  type    = string
  default = "dev"
}

variable "namespace" {
  type    = string
  default = "ecom"
}

variable "lb_type" {
  type    = string
  default = "application"
}

variable "vpc_id" {
  type = string
}

variable "tg" {
  type    = any
  default = {}
}

variable "security_groups" {
  type = list(any)
}

variable "subnets" {}