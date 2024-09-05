variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16" # users can override
}

variable "public_route" {
  default = "0.0.0.0/0"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "common_tags" {
  type    = map(any)
  default = {} // it is optional 

}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "igw_tags" {
  default = {}
}

variable "public_subnet_cidr" {
  type = list(any)
  validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "please give 2 public valid subnet cidr"
  }
}

variable "public_subnet_tags" {
  default = {}
}


variable "private_subnet_cidr" {
  type = list(any)
  validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "please give 2 private valid subnet cidr"
  }
}

variable "private_subnet_tags" {
  default = {}
}

variable "database_subnet_cidr" {
  type = list(any)
  validation {
    condition     = length(var.database_subnet_cidr) == 2
    error_message = "please give 2 valid database cidr"
  }
}

variable "database_subnet_tags" {
  default = {}
}

variable "nat_gw_tags" {

  default = {}

}

variable "public_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "private_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "database_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "vpc_peering_tags" {
  default = {}
}