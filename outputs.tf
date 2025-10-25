# Output ID CEN Instance agar bisa digunakan di module lain
output "cen_id" {
  description = "ID dari CEN Instance yang dibuat."
  value       = alicloud_cen_instance.cen.id
}

output "tr_vpc_attachment_id" {
  value       = alicloud_cen_transit_router_vpc_attachment.this.transit_router_attachment_id
  description = "The id of attachment between TR and VPC."
}