locals {
  keys = { for key in var.keys : key.name => {
    owners     = toset(try(compact(key.owners), [])),
    encrypters = toset(try(compact(key.encrypters), [])),
    decrypters = toset(try(compact(key.decrypters), []))
  } }

  encrypters = flatten([
    for name, key in local.keys : [
      for encrypter in key.encrypters : {
        key    = name,
        member = encrypter
      }
    ]
  ])

  decrypters = flatten([
    for name, key in local.keys : [
      for decrypter in key.decrypters : {
        key    = name,
        member = decrypter
      }
    ]
  ])

  owners = flatten([
    for name, key in local.keys : [
      for owner in key.owners : {
        key    = name,
        member = owner
      }
    ]
  ])
}

resource "google_kms_key_ring" "key_ring" {
  count = var.module_enabled ? 1 : 0

  name     = var.keyring
  project  = var.project
  location = var.location

  depends_on = [var.module_depends_on]
}

resource "google_kms_crypto_key" "key" {
  for_each = var.module_enabled ? local.keys : {}

  name            = each.key
  key_ring        = google_kms_key_ring.key_ring[0].self_link
  rotation_period = var.key_rotation_period

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels

  depends_on = [var.module_depends_on]
}

locals {
}

resource "google_kms_crypto_key_iam_member" "encrypter" {
  for_each = var.module_enabled ? {
    for encrypter in local.encrypters : "${encrypter.key}-${encrypter.member}" => {
      key    = encrypter.key
      member = encrypter.member
    }
  } : {}

  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = google_kms_crypto_key.key[each.value.key].self_link
  member        = each.value.member

  depends_on = [var.module_depends_on]
}

resource "google_kms_crypto_key_iam_member" "decrypter" {
  for_each = var.module_enabled ? {
    for decrypter in local.decrypters : "${decrypter.key}-${decrypter.member}" => {
      key    = decrypter.key
      member = decrypter.member
    }
  } : {}

  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = google_kms_crypto_key.key[each.value.key].self_link
  member        = each.value.member

  depends_on = [var.module_depends_on]
}

resource "google_kms_crypto_key_iam_member" "owner" {
  for_each = var.module_enabled ? {
    for owner in local.owners : "${owner.key}-${owner.member}" => {
      key    = owner.key
      member = owner.member
    }
  } : {}

  role          = "roles/owner"
  crypto_key_id = google_kms_crypto_key.key[each.value.key].self_link
  member        = each.value.member

  depends_on = [var.module_depends_on]
}
