variable "user_uuid" {
  type        = string
  description = "The UUID of the user"
   
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "The user_uuid must be in the format of a UUID"
  }
}

variable "bucket_name" {
  type        = string
 
}
