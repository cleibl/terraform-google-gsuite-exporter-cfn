# Terraform Stackdriver Aggregated Export to PubSub

The Terraform module can be used to provision a cloudfunction which gets Gsuite Admin Logs and syncs them to stackdriver

## Prerequisites 

The following GSuite Admin APIs are currently supported:

- `reports_v1` - [Reports API](https://developers.google.com/admin-sdk/reports/v1/get-start/getting-started)
    - `admin` - [Admin activity reports](https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-admin.html)
    - `drive` - [Google Drive activity reports](https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-drive.html)
    - `login` - [Login activity reports](https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-login.html)
    - `mobile` - [Mobile activity reports](https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-mobile.html)
    - `token` - [Authorization Token activity reports](https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-tokens.html)

The following destinations are currently supported:
- [Stackdriver Logging](https://cloud.google.com/logging/docs/)

## Requirements
* A GSuite Admin account
* A service account with:
  * [GSuite domain-wide delegation](https://developers.google.com/admin-sdk/reports/v1/guides/delegation) enabled.
  * The IAM role `roles/iam.tokenCreator` set on the organization.

## Usage
The usage of the module within your own main.tf file is as follows:

```hcl
    module "aggregated-export-to-pubsub" {
      source                          = ./path-to-your-source
      region                          = "us-central1"
      project_id                      = "example-project"
      name                            = "demo-cf-export"
      cs_schedule                     = "*/10 * * * *"
      gsuite_exporter_service_account = "gsuite-exporter-sa@example-project.iam.gserviceaccount.com
      gsuite_admin_user               = "admin@example.com"
    }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | The location of resources | string | `us-central1` | no |
| project_id |The ID of the project where the pub/sub topic will be installed  | string | - | yes |
| name | Prefix for resource naming | string | `demo-cf-export` | no |
| cs_schedule| The Schedule which to trigger the function | string | `*/10 * * * *` | no |
| gsuite_exporter_service-account| The email address of the service account which has been added to the gsuite admin consle and has [GSuite domain-wide delegation](https://developers.google.com/admin-sdk/reports/v1/guides/delegation)  | string | - | yes |
| gsuite_admin_user | The email of a gsuite admin user | string | - | yes |


## Outputs

| Name | Description |
|------|-------------|
| splunk-sa-key | Service Account Key used for Splunk to Subscribe to the Pubsub |
| topic-name    | The name of the pub/sub topic where logs are sent to |
| subscription-name | The name of the subscription which Splunk should pull logs from |
| project           | The Project which hosts the pubsub topic and subscription resources |
| organization_sink_writer | The Service Account associated with the organization sink.  Ensure this account has publish permissions to a pubsub topic |
