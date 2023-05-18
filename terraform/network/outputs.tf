output "public_subnet_id_a" {
  description = "The Public Subnet A ID"
  value = "${aws_subnet.public_subnet_a.id}"
}

output "public_subnet_id_b" {
  description = "The Public Subnet B ID"
  value = "${aws_subnet.public_subnet_b.id}"
}

output "private_subnet_id_a" {
  description = "The Private Subnet A ID"
  value = "${aws_subnet.private_subnet_a.id}"
}

output "private_subnet_id_b" {
  description = "The Private Subnet B ID"
  value = "${aws_subnet.private_subnet_b.id}"
}

output "public_sg_id" {
  description = "The Public Security Group ID"
  value = "${aws_security_group.public_sg.id}"
}

output "private_sg_id" {
  description = "The Private Security Group ID"
  value = "${aws_security_group.private_sg.id}"
}

output "public_lb_tg_id" {
  description = "The Public Elastic Load Balancer Target Group ARN"
  value = "${aws_lb_target_group.public_elb_tg.arn}"
}

output "private_lb_tg_id" {
  description = "The Private Elastic Load Balancer Target Group ARN"
  value = "${aws_lb_target_group.private_elb_tg.arn}"
}

output "public_lb_dns" {
  description = "The Public Elastic Load Balancer DNS"
  value = "${aws_lb.public_elb.dns_name}"
}

output "private_lb_dns" {
  description = "The Private Elastic Load Balancer DNS"
  value = "${aws_lb.private_elb.dns_name}"
}

output "db_subnet_a" {
  description = "The DB Subnet A ID"
  value = "${aws_subnet.db_subnet_a.id}"
}

output "db_subnet_b" {
  description = "The DB Subnet B ID"
  value = "${aws_subnet.db_subnet_b.id}"
}

output "db_sg_id" {
  description = "The DB Security Group ID"
  value = "${aws_security_group.database_sg.id}"
}