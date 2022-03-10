## Using default values from https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
## Soucre from https://www.olivercoding.com/2021-01-26-kubernetes-grafana/
grafana:
  adminPassword: ${grafana_adminPassword}
  grafana.ini:
    server:
      root_url: ${grafana_root_url}
    auth:
      disable_login_form: true
      oauth_auto_login: true
      disable_signout_menu: true
    auth.basic:
      enabled: false
    auth.generic_oauth:
      enabled: true
      name: "Keycloak"
      client_id: ${grafana_client_id}
      client_secret: ${grafana_client_secret}
      auth_url: ${grafana_auth_url}
      token_url: ${grafana_token_url}
      api_url: ${grafana_api_url}
      allow_sign_up: true
      role_attribute_path: "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'"
      email_attribute_name: email
      scopes: "openid profile email"
