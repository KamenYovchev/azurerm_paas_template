##################################################################################
# PROVIDERS
################################################################################## 
provider "azurerm" {

  version = "=2.28.0"
  features {}

}
##################################################################################
# DATA
##################################################################################

##################################################################################
# RESOURCES
##################################################################################
module "resource_group" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-resource-group.git"
  name = "${local.env_name}-rg"
  location  = var.location
}
module "storage_account" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-storage-account.git"
  name = "${replace(var.name,  "-", "")}storage${local.env_name}"
  location = var.location
  account_tier = var.account_tier
  replication_type = var.replication_type
  resource_group_name = module.resource_group.resource_group_name
}
module "sql_server" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-sql-server.git"
  name = "${var.name}-mssql-server-${local.env_name}"
  location = var.location
  sql_server_version = var.sql_server_version
  resource_group_name = module.resource_group.resource_group_name
  administrator_login = var.db_username
  administrator_login_password = var.db_pasword
  storage_endpoint = module.storage_account.storage_account_endpoint
  storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
  storage_account_access_key = module.storage_account.storage_account_access_key
  retention_in_days = var.retention_in_days
}

module "sql_database" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-sql-database.git"
  name = "${var.name}-mssql-db-${local.env_name}"
  resource_group_name = module.resource_group.resource_group_name
  location = var.location
  server_name = module.sql_server.sql_server_name
  storage_endpoint = module.storage_account.storage_account_endpoint
  create_mode = var.db_create_mode
  edition = var.db_edition[terraform.workspace]
  storage_account_access_key = module.storage_account.storage_account_access_key
  storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
  retention_in_days = var.retention_in_days
  depends_on = [module.sql_server]
}

module "sql_server_firewall_rule" {
  count = length(var.rules_names)
  source = "git@github.com:KamenYovchev/terraform-azurerm-sql-server-firewall-rule.git"
  name = element(var.rules_names, count.index)
  resource_group_name = module.resource_group.resource_group_name
  start_ip = element(var.start_ip, count.index)
  end_ip = element(var.end_ip, count.index)
  sql_server_name = module.sql_server.sql_server_name
  depends_on = [module.sql_server]

}

module "redis_cache" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-redis-cache.git"
  name = "${var.name}-redis-cahce-${local.env_name}"
  resource_group_name = module.resource_group.resource_group_name
  location = var.location
  sku_name = var.sku_name
  family = var.family
  capacity = var.capacity
  minimum_tls_version =var.minimum_tls_version
  enable_non_ssl_port = var.enable_non_ssl_port
  depends_on = [module.sql_server]
}


module "event_grid_topic" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-event-grid-topic.git"
  name = "${var.name}-event-grid-${local.env_name}"
  location = var.location
  resource_group_name = module.resource_group.resource_group_name
}

module "media_service_account" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-media-service-account.git"
  name = "${replace(var.name,  "-", "")}media${local.env_name}"
  location = var.location
  resource_group_name = module.resource_group.resource_group_name
  storage_account_id = module.storage_account.storage_account_id
  is_primary = var.is_primary
}

module "service_bus" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-service-bus.git"
  name = "${var.name}-service-bus-${local.env_name}"
  location = var.location
  resource_group_name = module.resource_group.resource_group_name
  sb_sku = var.sb_sku[terraform.workspace]
}

module "signalr" {
  source = "git@github.com:KamenYovchev/terraform-azurerm-signalr.git"
  name = "${var.name}-signalr-${local.env_name}"
  location = var.location
  resource_group_name = module.resource_group.resource_group_name
  sr_sku_name = var.sr_sku_name
  sr_sku_capacity = var.sr_sku_capacity
  flag = var.flag
  value = var.value
  allowed_origins = var.allowed_origins
}

module "app_service_plan" {
  source  = "git@github.com:KamenYovchev/terraform-azurerm-app-service-plan.git"
  name = "${var.name}app-svc-plan-${local.env_name}"
  location = var.location
  size = var.size[terraform.workspace]
  tier = var.tier[terraform.workspace]
  resource_group_name = module.resource_group.resource_group_name
  # insert the 5 required variables here
}

module "app_service" {
  count = length(var.applications)
  source  = "git@github.com:KamenYovchev/terraform-azurerm-app-service.git"
  name = "${element(var.applications, count.index)}-app-svc-${local.env_name}"
  app_service_plan_id = module.app_service_plan.app_service_plan_id
  resource_group_name = module.resource_group.resource_group_name
  location = var.location
  # insert the 4 required variables here
}

module "application_insights" {
  count = length(var.applications)
  source  = "git@github.com:KamenYovchev/terraform-azurerm-application-insights.git"
  name = "${element(var.applications, count.index)}-app-insights-${local.env_name}"
  resource_group_name = module.resource_group.resource_group_name
  location = var.location
  # insert the 4 required variables here
}





