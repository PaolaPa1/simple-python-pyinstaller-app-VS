# Provider Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Creamos la red Docker bridge para conectar Jenkins y dind
resource "docker_network" "jenkins_network" {
  name = "red_jenkins"
}

# Creamos el contenedor dind con la imagen docker:dind
resource "docker_container" "jenkins_docker" {
  name         = "jenkins-docker"
  image        = "docker:dind"
  network_mode = docker_network.jenkins_network.name
  ports {
    internal = 2376
    external = 2376
  }

  env = [
    "DOCKER_TLS_CERTDIR = /certs"
  ]

  restart = "no"

  privileged = "true"  

  volumes {
    volume_name    = "jenkins-docker-certs"
    container_path = "/certs/client"
  }

  volumes {
    volume_name    = "jenkins-data"
    container_path = "/var/jenkins_home"
  }

  volumes {
    #host_path      = "/var/run/docker.sock"  # Monta il socket Docker host nel container
    #container_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock:/var/run/docker.sock"
  }
  
  networks_advanced {
    name    = docker_network.jenkins_network.name
    aliases = ["jenkins_red"]
  }
}

