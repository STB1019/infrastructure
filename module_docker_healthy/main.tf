data "external" "wait" {
  program = ["${path.module}/docker_healthy.sh", var.container_name]
}