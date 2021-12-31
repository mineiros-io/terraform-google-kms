[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-kms)

[![Build Status](https://github.com/mineiros-io/terraform-google-kms/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-kms/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-kms.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-kms/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-kms

A [Terraform] module for managing [Cloud KMS](https://cloud.google.com/security-key-management) keyrings, zero or more keys in keyrings, and IAM role bindings on individual keys.  [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation:](#terraform-google-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following terraform resources:

- `google_kms_key_ring`
- `google_kms_crypto_key`
- `google_kms_crypto_key_iam_member`

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-kms" {
  source = "github.com/mineiros-io/terraform-google-kms?ref=v0.1.0"

  keyring  = "keyring-example"
  location = "global"
  project  = "my-project-id"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which the resources belong.

- [**`location`**](#var-location): *(**Required** `string`)*<a name="var-location"></a>

  The location for the keyring. A full list of valid locations can be found by running `gcloud kms locations list` or in the docs: https://cloud.google.com/kms/docs/locations.

- [**`keyring`**](#var-keyring): *(**Required** `string`)*<a name="var-keyring"></a>

  The resource name for the keyring.

- [**`keys`**](#var-keys): *(Optional `list(key)`)*<a name="var-keys"></a>

  A list of key objects describing how keys and IAM bindings are going to be created.

  Default is `[]`.

  Example:

  ```hcl
  keys = [{
    name       = "terraform-state-bucket-key"
    owners     = ["terraform@example-project.iam.gserviceaccount.com"]
    encrypters = [
      "group:one@example.com",
      "group:two@example.com"
    ]
    decrypters = ["group:three@example.com"]
  }]
  ```

  Each `key` object in the list accepts the following attributes:

  - [**`name`**](#attr-keys-name): *(**Required** `string`)*<a name="attr-keys-name"></a>

    The name of a specified key. It must belong to the specified keyring and matching the regular expression `[a-zA-Z0-9_-]{1,63}`

  - [**`owners`**](#attr-keys-owners): *(Optional `string`)*<a name="attr-keys-owners"></a>

    Identities that will be granted the KMS crypto key [owner privilege](https://cloud.google.com/kms/docs/reference/permissions-and-roles#predefined).

  - [**`encrypters`**](#attr-keys-encrypters): *(Optional `string`)*<a name="attr-keys-encrypters"></a>

    Identities that will be granted the KMS crypto key [encrypted privilege]((https://cloud.google.com/kms/docs/reference/permissions-and-roles)).

  - [**`decrypters`**](#attr-keys-decrypters): *(Optional `string`)*<a name="attr-keys-decrypters"></a>

    Identities that will be granted the kms crypto key [decrypters privilege]((https://cloud.google.com/kms/docs/reference/permissions-and-roles)).

- [**`key_rotation_period`**](#var-key_rotation_period): *(Optional `string`)*<a name="var-key_rotation_period"></a>

  Every time this period passes, generate a new version of the key and set it as the primary. The first rotation will take place after the specified period. The rotation period has the format of a decimal number with up to 9 fractional digits, followed by the letter `s` (seconds).

  Default is `"100000s"`.

- [**`key_algorithm`**](#var-key_algorithm): *(Optional `string`)*<a name="var-key_algorithm"></a>

  The algorithm to use when creating a version based on this template. For possible inputs please see https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm.

  Default is `"GOOGLE_SYMMETRIC_ENCRYPTION"`.

- [**`key_protection_level`**](#var-key_protection_level): *(Optional `string`)*<a name="var-key_protection_level"></a>

  The protection level to use when creating a version based on this template. Possible values are `SOFTWARE` and `HSM`.

  Default is `"SOFTWARE"`.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  Labels with user-defined metadata to apply to this resource.

  Default is `[]`.

## Module Outputs

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`key_ring`**

  All outputs of the created `google_kms_key_ring` resource.

- **`keys`**

  All outputs of the created `google_kms_crypto_key` resources.

- **`encrypter_iam_members`**

  All outputs of all created `google_kms_crypto_key_iam_member` resources for members with encrypter permissions.

- **`decrypter_iam_members`**

  All outputs of all created `google_kms_crypto_key_iam_member` resources for members with decrypter permissions.

- **`owner_iam_members`**

  All outputs of all created `google_kms_crypto_key_iam_member` resources for members with owner permissions.

## External Documentation

### Google Documentation

- https://cloud.google.com/security-key-management

### Terraform Google Provider Documentation:

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring
- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-kms
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-kms/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-kms.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-kms/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-kms/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-kms/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-kms/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-kms/issues
[license]: https://github.com/mineiros-io/terraform-google-kms/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-kms/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-kms/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-kms/blob/main/CONTRIBUTING.md
