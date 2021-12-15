provider "kubernetes" {
  version = "~> 1.10.0"

}

# resource "google_compute_address" "default" {
#   name   = var.network_name
#   region = var.region
# }


data "kubectl_filename_list" "manifests" {
    
    pattern = "./kubernetes-manifests/*.yaml"
}

resource "kubectl_manifest" "test" {
    count = length(data.kubectl_filename_list.manifests.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
}
