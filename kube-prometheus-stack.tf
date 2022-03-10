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

resource "kubectl_manifest" "ingressroute" {
  yaml_body  = <<-EOF
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: grafana
  namespace: monitoring-system
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`grafana.zelos.k8s.infra.erpf.de`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: kube-prometheus-stack-grafana
          port: 80
  tls:
    secretName: grafana-erpf-de-tls
  EOF

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.monitoring,
    kubectl_manifest.certificate
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body  = <<-EOF
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: grafana-erpf-de-tls
  namespace: monitoring-system
spec:
  secretName: grafana-erpf-de-tls
  issuerRef:
    name: cloudflare-letsencrypt-prod
    kind: ClusterIssuer
  commonName: grafana.zelos.k8s.infra.erpf.de
  dnsNames:
  - "grafana.zelos.k8s.infra.erpf.de"
  EOF

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.monitoring
  ]
}
