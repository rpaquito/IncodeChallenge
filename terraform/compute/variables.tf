variable "deploy_name" {
  description = "The deployment name"
}

variable "public_subnet_id_a" {
  description = "The public subnet A id"
}

variable "public_subnet_id_b" {
  description = "The public subnet B id"
}

variable "public_sg_id" {
  description = "The public securitygroup id"
}

variable "public_lb_tg_id" {
  description = "The public loadbalancer target group id"
}

variable "private_lb_dns" {
  description = "The private loadbalancer dns"
}

variable "private_subnet_id_a" {
  description = "The private subnet A id"
}

variable "private_subnet_id_b" {
  description = "The private subnet B id"
}

variable "private_sg_id" {
  description = "The private securitygroup id"
}

variable "private_lb_tg_id" {
  description = "The private loadbalancer target group id"
}

variable "db_username" {
  description = "The database username"
}

variable "db_password" {
  description = "The database password"
}

variable "db_endpoint" {
  description = "The database endpoint"
}