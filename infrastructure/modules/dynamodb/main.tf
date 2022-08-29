resource "aws_dynamodb_table" "_" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.partition_key
  range_key    = var.sort_key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi_parameters
    content {
      name            = local.name
      hash_key        = global_secondary_index.value.partition_key
      range_key       = global_secondary_index.value.sort_key
      projection_type = global_secondary_index.value.projection_type
    }
  }
}
