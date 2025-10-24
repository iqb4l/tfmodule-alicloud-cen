# Create CEN Instance
resource "alicloud_cen_instance" "cen" {
    cen_instance_name = var.cen_name
}

# Create Transit Router
resource "alicloud_cen_transit_router" "tr" {
    cen_id              = alicloud_cen_instance.cen.id
    transit_router_name = var.transit_router_name
}

# Create Transit Router CIDR
resource "alicloud_cen_transit_router_cidr" "tr_cidr" {
  transit_router_id        = alicloud_cen_transit_router.tr.transit_router_id
  cidr                     = var.tr_cidr
  transit_router_cidr_name = "${var.transit_router_name}-cidr"
  publish_cidr_route       = true
}


# Attach VPCs to Transit Router
resource "alicloud_cen_transit_router_vpc_attachment" "vpc_attachments" {
    for_each = { for idx, vpc in var.vpc_attachments : vpc.name => vpc }
    
    transit_router_vpc_attachment_name = each.value.name
    cen_id                             = alicloud_cen_instance.cen.id
    vpc_id                             = each.value.vpc_id
    transit_router_id                  = alicloud_cen_transit_router.tr.transit_router_id
    auto_publish_route_enabled         = true
    vpc_owner_id                       = each.value.vpc_owner_id
    
    dynamic "zone_mappings" {
      for_each = {
        for k, v in each.value.zone_vswitch_mappings : k => v 
        if v.vswitch_id != null && v.vswitch_id != ""
      }
      content {
        zone_id    = zone_mappings.value.zone_id
        vswitch_id = zone_mappings.value.vswitch_id
      }
    }
    
    depends_on = [
      alicloud_cen_transit_router.tr,
    ]
}

# Create Transit Router Route Table
resource "alicloud_cen_transit_router_route_table" "tr_rt" {
    transit_router_id               = alicloud_cen_transit_router.tr.transit_router_id
    transit_router_route_table_name = "${var.transit_router_name}-route-table"
}

# Associate and propagate route tables for each VPC
resource "alicloud_cen_transit_router_route_table_association" "rt_associations" {  
    for_each = alicloud_cen_transit_router_vpc_attachment.vpc_attachments
    
    transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_rt.transit_router_route_table_id
    transit_router_attachment_id  = each.value.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "rt_propagations" {  
  for_each = alicloud_cen_transit_router_vpc_attachment.vpc_attachments
  
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_rt.transit_router_route_table_id
  transit_router_attachment_id  = each.value.transit_router_attachment_id
}