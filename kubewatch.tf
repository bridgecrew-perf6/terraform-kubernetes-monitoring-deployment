# resource "helm_release" "kubewatch" {
#   name       = "kubewatch"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "kubewatch"

#   #   values = [
#   #     file("${path.module}/kubewatch-values.yaml")
#   #   ]

#   #   set_sensitive {
#   #     name  = "slack.token"
#   #     value = var.slack_app_token
#   #   }
# }
