variable "region" {
  type = string
}

variable "IAMPolicy" {
  type = list(string)
  default = ["Billing", "AWSBillingConductorFullAccess", "IAMUserChangePassword"]
}

variable "create_users" {
 type = list(string)
  default = ["arjun", "sushma", "gokul"]
}
