terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "elasticsearch_heap_usage_too_high_incident" {
  source    = "./modules/elasticsearch_heap_usage_too_high_incident"

  providers = {
    shoreline = shoreline
  }
}