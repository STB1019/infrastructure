resource "docker_image" "bind" {
  name = "bind9"
  build {
    path = "."
    dockerfile = "${path.module}/bind.dockerfile"
    tag  = ["bind9:9.18"]
    label = {
      author : "tetofonta"
    }
  }
}