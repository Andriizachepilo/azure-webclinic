variable "address_space" {
  type = list(string)
}

variable "node_address_prefix" {
  type = list(string)
}

variable "mysql_address_prefix" {
  type = list(string)
}

variable "node_security_group" {
  type = string
}

variable "db_security_group" {
  type = string
}

variable "agent_security_group" {
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

variable "agent_address_prefix" {
  type = list(string)
}

variable "api_gateway_security_group" {
  type = string
}

variable "api_address_prefix" {
  type = list(string)
}

