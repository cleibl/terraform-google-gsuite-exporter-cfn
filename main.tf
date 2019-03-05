provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
}

provider "google-beta" {
  project     = "${var.project_id}"
  region      = "${var.region}"
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/gsuite-exporter-cloudfunction"
  output_path = "${path.module}/gsuite-exporter.zip"
}

//ToDO: Add Required Services

resource "google_storage_bucket" "bucket" {
  provider = "google"
  project  = "${var.project_id}"
  name     = "${var.name}-gsuite-exporter"
}

resource "google_storage_bucket_object" "archive" {
  provider   = "google"
  name       = "gsuite-exporter.zip"
  bucket     = "${google_storage_bucket.bucket.name}"
  source     = "${data.archive_file.source.output_path}"
}

resource "google_pubsub_topic" "trigger-topic" {
  provider = "google"
  project  = "${var.project_id}"
  name     = "gsuite-admin-logs-topic-trigger"
} 


//Work Around due to non-supported features of cloudfunctions
resource "google_cloudfunctions_function" "gsuite-exporter-function" {
  provider              = "google-beta"
  name                  = "${var.name}-gsuite-exporter"
  description           = "Google Cloud Function to grab Gsuite Admin Audit Logs "
  available_memory_mb   = 128
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  timeout               = 60
  entry_point           = "run"
  service_account_email = "${var.gsuite_exporter_service_account}"
  runtime               = "python37"

  event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource = "${google_pubsub_topic.trigger-topic.name}"
  }

}

resource "google_cloud_scheduler_job" "gsuite-exporter-trigger-job" {
  provider    = "google-beta"
  project     = "${var.project_id}"
  name        = "${var.name}-gsuite-exporter-trigger"
  description = "A Cloud Scheduler Job to run the Gsuite-Exporter Cloud Function on a schedule"
  schedule    = "${var.cs_schedule}"
  pubsub_target {
    topic_name = "${google_pubsub_topic.trigger-topic.id}"
    data       = "${base64encode("{\"PROJECT_ID\":\"${var.project_id}\",\"GSUITE_ADMIN_USER\":\"${var.gsuite_admin_user}\"}")}"
  }
}