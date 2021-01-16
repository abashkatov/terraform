//provider "google" {
//  credentials = file(".tf-gcp-account.json")
//  project = var.project
//  region  = var.region
//}
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
//      version = "~> 2.7.2"
    }
  }
}

provider "docker" {
  host = "unix:///run/docker.sock"
}

# Download nginx version 1.17
resource docker_image nginx_img {
  name = "nginx:1.17"
}

resource "docker_network" "private_network" {
  name = "my_network"
}

# start the container
resource docker_container nginx {
  name = "terraform_nginx"
  image = docker_image.nginx_img.name
  ports {
    internal = 80
    external = 8080
  }

  mounts {
    target = "/etc/nginx/sites-enabled/"
    source = "/home/saty/projects/devops/terraform/nginx/"
    type = "bind"
  }

  mounts {
    target = "/var/log/nginx/"
    source = "/home/saty/projects/devops/terraform/var/log/nginx/"
    type = "bind"
  }

  networks_advanced {
    # change to the desired network name in docker
    name = "my_network"
    aliases = ["nginx"]
  }
}
