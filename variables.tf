
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "(Required) The region where KMS will be created."
  type        = string
}

variable "project" {
  description = "(Required) The ID of the project in which the resources belong."
  type        = string
}

variable "location" {
  description = "(Required) The location for the KeyRing. A full list of valid locations can be found by running 'gcloud kms locations list' or in the docs: https://cloud.google.com/kms/docs/locations"
  type        = string
}

variable "keyring" {
  description = "(Required) The resource name for the KeyRing."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "keys" {
  description = "(Optional) A list keys to be created. Each name belonging to the specified Google Cloud Platform KeyRing and match the regular expression '[a-zA-Z0-9_-]{1,63}'. Default is '[]'."
  type        = any
  #
  # TODO: Add types once Terraform supports optional types
  # type        = list(object({
  #   name       = string
  #   owners     = set(string)
  #   encrypters = set(string)
  #   decrypters = set(string)
  # }))
  #
  # Example:
  #
  # keys = [
  #   {
  #      name = "terraform-state-bucket-key"
  #      owners     = ["terraforn@example-project.iam.gserviceaccount.com"]
  #      encrypters = ["group:one@example.com","group:two@example.com"]
  #      decrypters = ["group:three@example.com"]
  #   }
  # ]
  default = []
}

variable "key_rotation_period" {
  description = "(Optional) Every time this period passes, generate a new CryptoKeyVersion and set it as the primary. The first rotation will take place after the specified period. The rotation period has the format of a decimal number with up to 9 fractional digits, followed by the letter s (seconds)."
  type        = string
  default     = "100000s"
}

variable "key_algorithm" {
  type        = string
  description = "(Optional) The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  type        = string
  description = "(Optional) The protection level to use when creating a version based on this template. Possible values are 'SOFTWARE' and 'HSM'."
  default     = "SOFTWARE"
}

variable "labels" {
  type        = map(string)
  description = "(Optional) Labels with user-defined metadata to apply to this resource."
  default     = {}
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
