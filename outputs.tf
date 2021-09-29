
# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# output "keys_self_links" {
#   description = "Map of key name => key self link."
#   value       = local.keys_by_name
# }

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "key_ring" {
  description = "All outputs of the created google_kms_key_ring resource."
  value       = try(google_kms_key_ring.key_ring, {})
}

output "keys" {
  description = "All outputs of the created google_kms_crypto_key resources."
  value       = try(google_kms_crypto_key.key, {})
}

output "encrypter_iam_members" {
  description = "All outputs of all created google_kms_crypto_key_iam_member resources for members with encrypter permissions."
  value       = try(google_kms_crypto_key_iam_member.encrypter, {})
}

output "decrypter_iam_members" {
  description = "All outputs of all created google_kms_crypto_key_iam_member resources for members with decrypter permissions."
  value       = try(google_kms_crypto_key_iam_member.decrypter, {})
}

output "owner_iam_members" {
  description = "All outputs of all created google_kms_crypto_key_iam_member resources for members with owner permissions."
  value       = try(google_kms_crypto_key_iam_member.owner, {})
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
