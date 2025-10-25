variable "cen_name" {
  type        = string
  description = "Name of the CEN instance"
}

variable "transit_router_name" {
  type        = string
  description = "Name of the transit router"
}

variable "tr_cidr" {
  type        = string
  description = "CIDR block for transit router"
}

variable "tr_vpc_attachment" {
  description = "The parameters of the attachment between TR and VPC."
  type = object({
    transit_router_attachment_name  = optional(string, null)
    auto_publish_route_enabled      = optional(bool, true)
    route_table_propagation_enabled = optional(bool, true)
    route_table_association_enabled = optional(bool, true)
  })
  default = {}
}

variable "vswitch_zone_mappings" {
  type = list(object({
    zone_id    = string
    vswitch_id = string
  }))
  description = "List of vSwitch and zone mappings for Transit Router attachment"
  default     = []
}


variable "network_nonprod_account_id" {
  description = "Network NonProd account ID"
  type        = string
}

variable "app_nonprod_account_id" {
  description = "App NonProd account ID"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "The ID of VPC to attach to CEN (from VPC module output)"
}

variable "vpc_owner_id" {
  type        = string
  description = "The owner ID of the VPC to attach to CEN"
}