check "nginx-check" {

  data "http" "nginx" {
    url = "http://${aws_instance.check.public_ip}:80"
  }

  assert {
    condition     = data.http.nginx.status_code == 200
    error_message = "nginx isn't up, please check"
  }
}

