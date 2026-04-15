cnt                = 1
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c", "ap-south-2a", "ap-south-2b", "ap-south-2c"]
is_create          = true
ingress_ports = {
  "ssh"   = ["192.140.152.132/32", 22, "tcp"]
  "http"  = ["192.140.152.132/32", 80, "http"]
  "https" = ["192.140.152.132/32", 443, "https"]
  "tcp"   = ["192.140.152.132/32", 8080, "tcp"]
}
region = "ap-south-1"
