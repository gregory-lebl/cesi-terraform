variable "project_name" {
  type        = string
  description = "Détermine le nom du projet qui sera utilisé pour générer le nom des ressources."
  default     = "gleblond"
}

resource "azurerm_resource_group" "rg_gleblond_01" {
  name     = "rg-${var.project_name}-01" #Nom du ressource group dans Azure
  location = "West Europe"
}

resource "azurerm_service_plan" "sp_gleblond_01" {
  name                = "asp-${var.project_name}-01" #Nom du service plan dans Azure
  resource_group_name = azurerm_resource_group.rg_gleblond_01.name
  location            = azurerm_resource_group.rg_gleblond_01.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "webapp_gleblond_01" {
  name                = "webapp-${var.project_name}-${uuid()}-01"
  resource_group_name = azurerm_resource_group.rg_gleblond_01.name
  location            = azurerm_service_plan.sp_gleblond_01.location
  service_plan_id     = azurerm_service_plan.sp_gleblond_01.id

  site_config {}

  # Util si on veut éviter de détruire sa base de données
  lifecycle {
    prevent_destroy = true
  }
}
