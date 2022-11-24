data docker_registry_image postgres {
  name = "postgres:alpine"
}

resource docker_image postgres {
  name          = data.docker_registry_image.postgres.name
  pull_triggers = [data.docker_registry_image.postgres.sha256_digest]
  keep_locally = true
}