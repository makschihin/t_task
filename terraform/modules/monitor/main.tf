terraform {
  required_providers {
    datadog = {
      sousource = "DataDog/datdog"
    }
  } 
}
####################################
# Create Datadog Monitor
####################################
resource "datadog_monitor" "nginx_monitor" {
  name = "${var.enviroment}_nginx"
  type = "service check"
  message = "Something wrong with Nginx"
  query = "'process.up'.over('process:nginx','region:us-east-2').last(2).count_by_status()"
  
}