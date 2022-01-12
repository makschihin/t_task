terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  } 
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

####################################
# Create Datadog Monitor
####################################
resource "datadog_monitor" "nginx_monitor" {
  name = "${var.enviroment}_nginx"
  type = "service check"
  message = "Something wrong with Nginx"
  query = "${var.query_for_check}"
}