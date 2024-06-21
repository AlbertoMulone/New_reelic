data "newrelic_entity" "data_entity" {
  name = var.name
}

resource "newrelic_entity_tags" "data_entity_tag" {
  guid = data.newrelic_entity.data_entity.guid

  dynamic "tag" {
    for_each = {
      for key, value in var.tag :
      key => value
    }
    content {
      key    = tag.key
      values = [tag.value]
    }
  }
}
