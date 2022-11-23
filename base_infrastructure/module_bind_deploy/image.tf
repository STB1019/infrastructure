data docker_registry_image bind {
  name = "internetsystemsconsortium/bind9:9.18"
}

resource docker_image bind {
  name          = data.docker_registry_image.bind.name
  pull_triggers = [data.docker_registry_image.bind.sha256_digest]
  keep_locally = true
}
