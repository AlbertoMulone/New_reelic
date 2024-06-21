# notification destination
data "newrelic_notification_destination" "lcert_notification_destination" {
  name = var.notification
}

resource "newrelic_notification_channel" "lcert_notification_channel" {
  name    = "${var.name_prefix} notification channel"
  type    = "WEBHOOK"
  product = "IINT"

  destination_id = data.newrelic_notification_destination.lcert_notification_destination.id

  property {
    key   = "payload"
    label = "template"
    value = <<EOF
{
  "tags": "${var.notification}",
  "teams": "null",
  "recipients": "null",
  "payload": 
  {
    "condition_id": {{json accumulations.conditionFamilyId.[0]}},
    "condition_name": {{json accumulations.conditionName.[0] }},
    "current_state": {{#if issueClosedAtUtc}} "closed" {{else if issueAcknowledgedAt}} "acknowledged" {{else}} "open"{{/if}},
    "details": {{json issueTitle}},
    "event_type": "Incident",
    "incident_acknowledge_url": {{json issueAckUrl }},
    "incident_api_url": "N/A",
    "incident_id": {{json issueId }},
    "incident_url": {{json issuePageUrl }},
    "owner": "N/A",
    "policy_name": {{ json accumulations.policyName.[0] }},
    "policy_url":  {{json issuePageUrl }},
    "runbook_url": {{ json accumulations.runbookUrl.[0] }},
    "severity": "{{#eq 'HIGH' priority}}WARNING{{else}}{{priority}}{{/eq}}",
    "targets":[ 
    { 
      "id": "{{labels.targetId.[0]}}",
      "name": "{{#if accumulations.targetName}}{{escape accumulations.targetName.[0]}}{{else if entitiesData.entities}}{{escape entitiesData.entities.[0].name}}{{else}}N/A{{/if}}",
      "link": "{{issuePageUrl}}",
      "product": "{{accumulations.conditionProduct.[0]}}",
      "type": "{{#if entitiesData.types.[0]}}{{entitiesData.types.[0]}}{{else}}N/A{{/if}}",
      "labels": { 
        {{#each accumulations.rawTag}}"{{escape @key}}": {{#if this.[0]}}{{json this.[0]}}{{else}}"empty"{{/if}}{{#unless @last}},{{/unless}}{{/each}}
      } 
    }],
    "metadata":
    { 
      {{#if locationStatusesObject}}"location_statuses": {{json locationStatusesObject}},{{/if}}
      {{#if accumulations.metadata_entity_type}}"entity.type": {{json accumulations.metadata_entity_type.[0]}},{{/if}}
      {{#if accumulations.metadata_entity_name}}"entity.name": {{json accumulations.metadata_entity_name.[0]}}{{/if}}
    },
    "radar_entity":
    {
      "accountId": {{json accumulations.tag.accountId.[0]}},
      "domain": {{json accumulations.conditionProduct.[0]}},
      "domainId": {{json issueId}},
      "entityGuid": {{json entitiesData.entities.[0].id}},
      "name": {{#if accumulations.targetName}}{{json accumulations.targetName.[0]}}{{else if entitiesData.entities}}{{json entitiesData.entities.[0].name}}{{else}}"NA"{{/if}},
      "type": {{#if entitiesData.types.[0]}}{{json entitiesData.types.[0]}}{{else}}"NA"{{/if}}
    },
    {{#if accumulations.evaluationName}}"condition_metric_name": {{json accumulations.evaluationName.[0]}},{{/if}}
    {{#if accumulations.evaluationMetricValueFunction}}"condition_metric_value_function": {{json accumulations.evaluationMetricValueFunction.[0]}},{{/if}}
    {{#if nrAccountId}} "account_id": {{nrAccountId}},{{/if}}
    "account_name": {{json accumulations.tag.account.[0]}}, 
    "timestamp": {{updatedAt}}
  }
}
EOF

  }
}

resource "newrelic_workflow" "lcert_workflow" {
  name = "${var.name_prefix} workflow"

  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = "Filter-name"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [ var.policy_id ]
    }
    predicate {
      attribute = "priority"
      operator  = "EQUAL"
      values    = ["CRITICAL"]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.lcert_notification_channel.id
    notification_triggers = ["ACKNOWLEDGED", "ACTIVATED", "CLOSED"]
  }

}
