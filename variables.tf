 
##################################################################################
# VARIABLES
##################################################################################

variable "location" {
  type    = string
  default = "westeurope"
}

variable "name" {
  type    = string
  default = "wize"
}

variable "start_ip" {
    type = list(string)
    default = ["52.163.51.40", "0.0.0.0"]
}

variable "end_ip" {
    type = list(string)
    default = ["52.163.51.40", "0.0.0.0"]
}

variable "rules_names" {
    type = list(string)
    default = ["client-ip","allow_azure_services"]
}

variable "applications" {
    default = ["public-api", "assessment", "configuration", "employee", "identity",  "learning", "report", "talent", "wizechat", "worker1", "worker2", "worker3"]
}

variable "account_tier" {
    type = string
    default = "Standard"
}

variable "replication_type" {
    type = string
    default = "LRS"
}
  
variable "db_username" {
    description = "Database administrator login"
    type = string
    default = "sqladmin"
    #sensitive = true
}

variable "db_pasword" {
    description = "Database administrator password"
    type = string
    default = "Vu2C8N4eE6hGHPBw"
    #sensitive = true
}

variable "retention_in_days" {
    type = number
    default = 7
}

variable "storage_account_access_key_is_secondary" {
    type = bool
    default = true
}

variable "sql_server_version" {
  type = string
  description = "(optional) version of sql server instance"
  default = "12.0"
}

variable sku_name {
    type = string
    default = "Premium" 
}

variable family {
    type = string
    default = "P"
}

variable "db_edition" {
    type = map(string)
    default = {
        Integration = "Standard"
        Demo = "Standard"
        Performance = "GeneralPurpose"
        Staging = "GeneralPurpose"
        Production = "GeneralPurpose"

    }
}

variable "db_create_mode" {
    type = string
    default = "Default"
}


variable "capacity" {
    type = number
    default = 1
}

variable "minimum_tls_version" {
    type = number 
    default = 1.2
}

variable "enable_non_ssl_port" {
    type = bool
    default  = true
}

variable "cs_sku_name" {
    type = string
    default = "S0"
}

variable "kind" {
    type = string
    default = "QnAMaker"
}

variable "is_primary" {
    type = bool
    default = true
}

variable "sb_sku" {
    type = map(string)
    default = {
        Integration = "Standard"
        Performance = "Premium"
        Staging = "Premium"
        Demo = "Standard"
        Production = "Premium"
    }
}

variable "sr_sku_name" {
    type = string
    default = "Standard_S1"
}

variable "sr_sku_capacity" {
    type = number
    default = 1
}

variable "allowed_origins" {
    type = list(string)
    default = ["*"]
}

variable "flag" {
    type = string
    default = "ServiceMode"
}

variable "value" {
    type = string
    default = "Default"
}

variable size {
    type = map(string)
    default = {
        Integration = "P2V3"
    }

}

variable tier {
    type = map(string)
    default = {
        Integration = "PremiumV2"
    }

}

variable "plan_id" {
  default = ""
  description = "The app service plan to use.  If none is passed it will create one"
}
##################################################################################
# LOCALS
##################################################################################

locals {

env_name = lower(terraform.workspace)

}