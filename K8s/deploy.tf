resource "kubernetes_deployment_v1" "nginx-deploy" {
  metadata {
    labels = {
      "app" = "nginx"
    }
    name      = "nginx"
    namespace = "default"
  }

  spec {
    replicas = "1"

    selector {
      match_labels = {
        "app" = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "nginx"
        }
      }
      spec {
        restart_policy = "Always"
        container {
          image             = "nginx"
          image_pull_policy = "Always"
          name              = "nginx"
          port {
            container_port = 80
            protocol       = "TCP"
          }

        }
      }
    }
  }
}


# kubernetes_service_v1.nginx-svc:
resource "kubernetes_service_v1" "nginx-svc" {

  metadata {
    labels = {
      "app" = "nginx"
    }
    name      = "nginx-svc"
    namespace = "default"
  }

  spec {
    selector = {
      "app" = "nginx"
    }
    type = "NodePort"

    port {
      node_port   = 32557
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
  }
}
