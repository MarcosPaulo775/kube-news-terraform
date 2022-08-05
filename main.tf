terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token 
}

resource "digitalocean_kubernetes_cluster" "marcosk8s" {
  name   = var.k8s_name 
  region = var.region
  version = "1.23.9-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "bar" {
  cluster_id = digitalocean_kubernetes_cluster.marcosk8s.id

  name       = "premium"
  size       = "s-4vcpu-8gb"
  node_count = 2

}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

resource "local_file" "kub_config" {
    content  = digitalocean_kubernetes_cluster.marcosk8s.kube_config.0.raw_config
    filename = "kube_config.yaml"
}
