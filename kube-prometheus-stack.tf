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

data "template_file" "prometheus_stack" {
  template = file("${path.module}/templates/kube-prometheus-stack.values.tpl")
  vars = {
    grafana_adminPassword = var.grafana_adminPassword
    grafana_root_url      = var.grafana_root_url
    grafana_client_id     = var.grafana_client_id
    grafana_client_secret = var.grafana_client_secret
    grafana_auth_url      = var.grafana_auth_url
    grafana_token_url     = var.grafana_token_url
    grafana_api_url       = var.grafana_api_url
  }
}

resource "helm_release" "prometheus_stack" {
  name            = "prometheus-stack"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "kube-prometheus-stack"
  version         = "35.1.0"
  namespace       = kubernetes_namespace.monitoring.metadata[0].name
  cleanup_on_fail = true
  timeout         = 300

  depends_on = [
    kubernetes_namespace.monitoring,
  ]

  values = [
    data.template_file.prometheus_stack.rendered
  ]
}

# data "template_file" "prometheus_adapter" {
#   template = file("${path.module}/templates/prometheus-adapter.values.tpl")
# }

# resource "helm_release" "prometheus_adapter" {
#   name            = "prometheus-adapter"
#   repository      = "https://prometheus-community.github.io/helm-charts"
#   chart           = "prometheus-adapter"
#   version         = "3.2.1"
#   namespace       = kubernetes_namespace.monitoring.metadata[0].name
#   cleanup_on_fail = true

#   depends_on = [
#     kubernetes_namespace.monitoring,
#   ]

#   values = [
#     data.template_file.prometheus_adapter.rendered
#   ]

#   set {
#     name  = "prometheus.url"
#     value = "http://${helm_release.prometheus_stack.name}-kube-prom-prometheus.${kubernetes_namespace.monitoring.metadata[0].name}.svc"
#   }

# }

# data "template_file" "metrics_server" {
#   template = file("${path.module}/templates/metrics-server.values.tpl")
# }

# resource "helm_release" "metrics_server" {
#   name            = "metrics-server"
#   repository      = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart           = "metrics-server"
#   version         = "3.8.2"
#   namespace       = kubernetes_namespace.monitoring.metadata[0].name
#   cleanup_on_fail = true

#   depends_on = [
#     kubernetes_namespace.monitoring,
#   ]

#   values = [
#     data.template_file.metrics_server.rendered
#   ]

# }
