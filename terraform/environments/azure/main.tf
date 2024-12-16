module "azure" {
  source = "../../modules/azure"
  providers = {
    azapi = azapi
    azurerm = azurerm
  }
  resource_group_name = "logging-benchmarks"
  resource_group_location = "germanywestcentral"
  username = var.username
}
