resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring-system"
    }
    labels = {
      managed-by = "zelos-installer"
    }
    name = "monitoring-system"
  }
}

data "template_file" "this" {
  template = file("${path.module}/templates/kube-prometheus-stack.values.tpl")
  vars = {
    grafana_adminPassword = var.grafana_adminPassword
    grafana_root_url = var.grafana_root_url
    grafana_client_id = var.grafana_client_id
    grafana_client_secret = var.grafana_client_secret
    grafana_auth_url = var.grafana_auth_url
    grafana_token_url = var.grafana_token_url
    grafana_api_url = var.grafana_api_url
  }
}

resource "helm_release" "monitoring" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "20.0.1"
  namespace  = "monitoring-system"

  depends_on = [
    kubernetes_namespace.monitoring,
  ]

  values = [
    data.template_file.this.rendered
  ]
}
