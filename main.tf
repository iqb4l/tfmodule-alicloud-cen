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
resource "alicloud_cen_transit_router_vpc_attachment" "this" {    
    transit_router_vpc_attachment_name = var.tr_vpc_attachment.transit_router_attachment_name
    cen_id                             = alicloud_cen_instance.cen.id
    vpc_id                             = var.vpc_id
    transit_router_id                  = alicloud_cen_transit_router.tr.transit_router_id
    auto_publish_route_enabled         = var.tr_vpc_attachment.auto_publish_route_enabled
    vpc_owner_id                       = var.vpc_owner_id
    
    dynamic "zone_mappings" {
      for_each = var.vswitch_zone_mappings
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
    transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_rt.transit_router_route_table_id
    transit_router_attachment_id  =  alicloud_cen_transit_router_vpc_attachment.this.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "rt_propagations" {  
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_rt.transit_router_route_table_id
  transit_router_attachment_id  =  alicloud_cen_transit_router_vpc_attachment.this.transit_router_attachment_id
}