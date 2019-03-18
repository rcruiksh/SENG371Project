resource "azurerm_resource_group" "project2" {
  name     = "project2-d"
  location = "westus"
}

resource "azurerm_app_service_plan" "project2" {
    name                    = "project2-app-service-plan"
    resource_group_name     = "${azurerm_resource_group.project2.name}"
    location                = "${azurerm_resource_group.project2.location}"
    kind                    = "FunctionApp"

    sku {
        tier = "Dynamic"
        size = "Y1"
    }
}

resource "azurerm_storage_account" "project2" {
  name                     = "project2bc"
  resource_group_name      = "${azurerm_resource_group.project2.name}"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "project2queue" {
    name                    = "queue"
    resource_group_name     = "${azurerm_resource_group.project2.name}"
    storage_account_name    = "${azurerm_storage_account.project2.name}"
    container_access_type   = "private"
}

resource "azurerm_storage_container" "project2output" {
    name                    = "output"
    resource_group_name     = "${azurerm_resource_group.project2.name}"
    storage_account_name    = "${azurerm_storage_account.project2.name}"
    container_access_type   = "private"
}

resource "azurerm_function_app" "project2" {
    name                        = "data-science-wrapper"
    resource_group_name         = "${azurerm_resource_group.project2.name}"
    location                    = "${azurerm_resource_group.project2.location}"
    app_service_plan_id         = "${azurerm_app_service_plan.project2.id}"
    storage_connection_string   = "${azurerm_storage_account.project2.primary_connection_string}"
}
