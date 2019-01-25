variable "project_id" {
    description = "The Project ID to provision resources into"
}

variable "region" {
    // To-Do: Add request to add region as parameter for cloudfunction resource
    description = "The Region to deploy the cloudfunction.  Currently this is only available in us-central-1"
    default = "us-central1"
}
variable "name" {
    description = "The Prefix for resource names"
}

variable "gsuite_admin_user" {
    //TO-DO: Why does the Function need this information?
    description = "The GSUITE Admin User Email address used in the function"
}


variable "cs_schedule" {
    description = "The Schedule which to trigger the function"
    default = "*/10 * * * *"
 }

 variable "gsuite_exporter_service_account" {
     description = "The Domain-Wide Delegated Service account with permissions to pull gsuite admin logs"
  }