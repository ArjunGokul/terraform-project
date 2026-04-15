resource "kubernetes_namespace_v1" "arjun" {
  metadata {
    name = "arjun"
  }
}

resource "kubernetes_pod_v1" "httpd" {
  metadata {
    name      = "httpd"
    namespace = kubernetes_namespace_v1.arjun.id
    labels = {
      name = "httpd"
    }
  }
  spec {
    container {
      image = "httpd:alpine"
      name  = "httpd"
      env {
        name  = "HTTPD_PORT"
        value = "8080"
      }
      port {
        container_port = 80
      }
    }
  }
}

resource "local_file" "store" {
  filename   = "/home/nasg0725/Devops/Terraform/K8s/node_name.txt"
  content    = kubernetes_pod_v1.httpd.spec[0].node_name
  depends_on = [kubernetes_pod_v1.httpd]
}

resource "kubernetes_service_v1" "httpd-service" {
  metadata {
    name      = "httpd-service"
    namespace = kubernetes_namespace_v1.arjun.id
    labels = {
      name = "httpd"
    }
  }
  spec {
    selector = {
      name = "httpd"
    }
    port {
      port = 80
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_pod_v1.httpd]
}

