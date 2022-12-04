data docker_registry_image authentik {
  name = "ghcr.io/goauthentik/server:2022.11.3"
}

resource docker_image authentik {
  name          = data.docker_registry_image.authentik.name
  pull_triggers = [data.docker_registry_image.authentik.sha256_digest]
  keep_locally = true
}

data docker_registry_image redis {
  name = "redis:alpine"
}

resource docker_image redis {
  name          = data.docker_registry_image.redis.name
  pull_triggers = [data.docker_registry_image.redis.sha256_digest]
  keep_locally = true
}