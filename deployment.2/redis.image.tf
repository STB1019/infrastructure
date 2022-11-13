data docker_registry_image redis {
  name = "redis:alpine"
}

resource docker_image redis {
  name          = data.docker_registry_image.redis.name
  pull_triggers = [data.docker_registry_image.redis.sha256_digest]
  keep_locally = true
}