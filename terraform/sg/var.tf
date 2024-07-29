variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "ingress" {
  type = any
  default = {
    ssh = {
      port = 22
    },
    http = {
      description = "TLS from VPC"
      port        = 80

    },
    tomcat = {
      port        = 8080
      cidr_blocks = ["172.25.12.31/32"]
    }
  }
}


# demo