variable "vn_name" {
  type = string
}

variable "address_space" {
  type = any
}

variable "private_address_prefix" {
  type = list(string)
}

variable "public_address_prefix" {
  type = list(string)
}

variable "private_subnet_name" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "public_security_group" {
  type = string
}

variable "private_security_group" {
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
