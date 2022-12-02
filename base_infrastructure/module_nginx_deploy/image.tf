data docker_registry_image nginx {

  name = "nginx:alpine"
}

resource docker_image nginx {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
  keep_locally = true
}