data "external" "wait" {
  program = ["${path.module}/docker_sighup.sh", var.container_name]
}