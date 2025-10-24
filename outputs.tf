# Output ID CEN Instance agar bisa digunakan di module lain
output "cen_id" {
  description = "ID dari CEN Instance yang dibuat."
  value       = alicloud_cen_instance.cen.id

}