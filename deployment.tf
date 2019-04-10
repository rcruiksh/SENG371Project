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
    name                     = "braidencproject2"
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

resource "azurerm_storage_container" "project2temp" {
    name                    = "temp"
    resource_group_name     = "${azurerm_resource_group.project2.name}"
    storage_account_name    = "${azurerm_storage_account.project2.name}"
    container_access_type   = "private"
}

resource "azurerm_storage_blob" "test-blob" {
    name = "text.txt"
    resource_group_name    = "${azurerm_resource_group.project2.name}"
    storage_account_name   = "${azurerm_storage_account.project2.name}"
    storage_container_name = "${azurerm_storage_container.project2temp.name}"

    type   = "block"
    source = "./test.txt"
    content_type = "text/plain"
}

resource "azurerm_storage_container" "function-code" {
    name                    = "function-code"
    resource_group_name     = "${azurerm_resource_group.project2.name}"
    storage_account_name    = "${azurerm_storage_account.project2.name}"
    container_access_type   = "private"
}

resource "azurerm_storage_blob" "code-blob" {
    name = "app.zip"
    resource_group_name    = "${azurerm_resource_group.project2.name}"
    storage_account_name   = "${azurerm_storage_account.project2.name}"
    storage_container_name = "${azurerm_storage_container.function-code.name}"

    type   = "block"
    source = "./app.zip"
    content_type = "application/zip"
}

data "azurerm_storage_account_sas" "project2" {
    connection_string = "${azurerm_storage_account.project2.primary_connection_string}"
    https_only        = true

    resource_types {
        service   = false
        container = false
        object    = true
    }

    services {
        blob  = true
        queue = false
        table = false
        file  = false
    }

    start  = "2019-03-18"
    expiry = "2029-03-18"

    permissions {
        read    = true
        write   = false
        delete  = false
        list    = false
        add     = false
        create  = false
        update  = false
        process = false
    }
}

resource "azurerm_application_insights" "project2" {
    name                = "project2-appinsights"
    location            = "westus2"
    resource_group_name = "${azurerm_resource_group.project2.name}"
    application_type    = "Web"
}

resource "azurerm_function_app" "project2" {
    name                        = "braidenc-data-science-wrapper"
    resource_group_name         = "${azurerm_resource_group.project2.name}"
    location                    = "${azurerm_resource_group.project2.location}"
    app_service_plan_id         = "${azurerm_app_service_plan.project2.id}"
    storage_connection_string   = "${azurerm_storage_account.project2.primary_connection_string}"
    # version                     = "beta"

    app_settings {
        HASH                        = "${filebase64sha256("./app.zip")}"
        FUNCTION_WORKER_RUNTIME     = "python"
        WEBSITE_RUN_FROM_PACKAGE    = "https://${azurerm_storage_account.project2.name}.blob.core.windows.net/${azurerm_storage_container.function-code.name}/${azurerm_storage_blob.code-blob.name}${data.azurerm_storage_account_sas.project2.sas}"
        # https://braidencproject2.blob.core.windows.net/function-code/app.zip
        APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.project2.instrumentation_key}"
    }
}
