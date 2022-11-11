output "container_name" {
  value = data.external.wait.result.container
}

output "container_ip" {
  value = data.external.wait.result.ip
}