resource "shoreline_notebook" "elasticsearch_heap_usage_too_high_incident" {
  name       = "elasticsearch_heap_usage_too_high_incident"
  data       = file("${path.module}/data/elasticsearch_heap_usage_too_high_incident.json")
  depends_on = [shoreline_action.invoke_elasticsearch_heap_check,shoreline_action.invoke_elasticsearch_heap_size_check,shoreline_action.invoke_update_heap_size]
}

resource "shoreline_file" "elasticsearch_heap_check" {
  name             = "elasticsearch_heap_check"
  input_file       = "${path.module}/data/elasticsearch_heap_check.sh"
  md5              = filemd5("${path.module}/data/elasticsearch_heap_check.sh")
  description      = "Large volume of data being indexed at a high rate causing heap memory usage to increase beyond the limit."
  destination_path = "/agent/scripts/elasticsearch_heap_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "elasticsearch_heap_size_check" {
  name             = "elasticsearch_heap_size_check"
  input_file       = "${path.module}/data/elasticsearch_heap_size_check.sh"
  md5              = filemd5("${path.module}/data/elasticsearch_heap_size_check.sh")
  description      = "Misconfigured Elasticsearch JVM heap size, leading to insufficient memory allocation."
  destination_path = "/agent/scripts/elasticsearch_heap_size_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_heap_size" {
  name             = "update_heap_size"
  input_file       = "${path.module}/data/update_heap_size.sh"
  md5              = filemd5("${path.module}/data/update_heap_size.sh")
  description      = "Increase the heap size of Elasticsearch to accommodate the increased usage."
  destination_path = "/agent/scripts/update_heap_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_elasticsearch_heap_check" {
  name        = "invoke_elasticsearch_heap_check"
  description = "Large volume of data being indexed at a high rate causing heap memory usage to increase beyond the limit."
  command     = "`chmod +x /agent/scripts/elasticsearch_heap_check.sh && /agent/scripts/elasticsearch_heap_check.sh`"
  params      = ["ELASTICSEARCH_INSTANCE_URL"]
  file_deps   = ["elasticsearch_heap_check"]
  enabled     = true
  depends_on  = [shoreline_file.elasticsearch_heap_check]
}

resource "shoreline_action" "invoke_elasticsearch_heap_size_check" {
  name        = "invoke_elasticsearch_heap_size_check"
  description = "Misconfigured Elasticsearch JVM heap size, leading to insufficient memory allocation."
  command     = "`chmod +x /agent/scripts/elasticsearch_heap_size_check.sh && /agent/scripts/elasticsearch_heap_size_check.sh`"
  params      = ["EXPECTED_HEAP_SIZE","ELASTICSEARCH_HOST","ELASTICSEARCH_PORT"]
  file_deps   = ["elasticsearch_heap_size_check"]
  enabled     = true
  depends_on  = [shoreline_file.elasticsearch_heap_size_check]
}

resource "shoreline_action" "invoke_update_heap_size" {
  name        = "invoke_update_heap_size"
  description = "Increase the heap size of Elasticsearch to accommodate the increased usage."
  command     = "`chmod +x /agent/scripts/update_heap_size.sh && /agent/scripts/update_heap_size.sh`"
  params      = ["PATH_TO_ELASTICSEARCH_CONFIG_FILE","NEW_HEAP_SIZE_IN_MB"]
  file_deps   = ["update_heap_size"]
  enabled     = true
  depends_on  = [shoreline_file.update_heap_size]
}

