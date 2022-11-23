output "container_name" {
  value = docker_container.bind.name
}

output "container_ip" {
  value = docker_container.bind.network_data[0].ip_address 
}