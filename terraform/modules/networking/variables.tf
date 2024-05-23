variable "address_space" {
  type = any
}

variable "private_address_prefix" {
  type = list(string)
}

variable "public_address_prefix" {
  type = list(string)
}

variable "aks_security_group" {
  type = string
}

variable "db_security_group" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "create_cluster" {
  type = bool
}
