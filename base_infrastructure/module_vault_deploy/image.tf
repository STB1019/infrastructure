data docker_registry_image vault {
  name = "vault"
}

resource docker_image vault {
  name          = data.docker_registry_image.vault.name
  pull_triggers = [data.docker_registry_image.vault.sha256_digest]
  keep_locally = true
}