variable "address_space" {
  type = list(string)
}

variable "pod_address_prefix" {
  type = list(string)
}

variable "mysql_address_prefix" {
  type = list(string)
}

variable "pod_security_group" {
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

variable "agent_address_prefix" {
  type = list(string)
}

variable "api_gateway_security_group" {
  type = string
}

variable "api_address_prefix" {
  type = list(string)
}

variable "bgp_route_propagation" {
 type = bool
}
