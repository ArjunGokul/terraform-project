module "s3-creation" {
  source                = "../../modules/aws-s3-creation/"
  static_website_enable = false
  region                = "ap-south-1"
  project               = "terraform-poc"
}
