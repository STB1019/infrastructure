data docker_registry_image authentik {
  name = "ghcr.io/goauthentik/server:2022.7"
}

resource docker_image authentik {
  name          = data.docker_registry_image.authentik.name
  pull_triggers = [data.docker_registry_image.authentik.sha256_digest]
  keep_locally = true
}