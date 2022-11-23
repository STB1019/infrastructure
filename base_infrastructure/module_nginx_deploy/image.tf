data docker_registry_image nginx {
  count = var.use_http3 ? 0 : 1

  name = "nginx:alpine"
}

resource docker_image nginx {
  count = var.use_http3 ? 0 : 1

  name          = data.docker_registry_image.nginx[0].name
  pull_triggers = [data.docker_registry_image.nginx[0].sha256_digest]
  keep_locally = true
}

resource "docker_image" "nginx_http3" {
  count = var.use_http3 ? 1 : 0

  name = "nginx:http3"
  build {
    path = path.module
    dockerfile = "./nginx.http3.dockerfile"
    tag = ["nginx:quic"]
    remove = false
  }
  triggers = {
    dir_sha1 = filesha1("${path.module}/nginx.http3.dockerfile")
  }
}