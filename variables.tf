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

variable "vpc_attachments" {
  type = list(object({
    name                  = string
    vpc_id                = string
    vpc_owner_id          = string
    zone_vswitch_mappings = map(object({
      zone_id    = string
      vswitch_id = string
    }))
  }))
  description = "List of VPC attachments"
}

variable "network_nonprod_account_id" {
  description = "Network NonProd account ID"
  type        = string
}

variable "app_nonprod_account_id" {
  description = "App NonProd account ID"
  type        = string
}