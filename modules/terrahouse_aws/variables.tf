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

variable "index_html_filepath" {
  type        = string
  
  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified index.html file path is not valid"
  }
}

variable "error_html_filepath" {
  type        = string
  
  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified index.html file path is not valid"
  }
}
