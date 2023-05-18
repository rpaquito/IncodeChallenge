output "mysql_endpoint" {
  description = "The Database Endpoint"
  value = "${aws_db_instance.mysql.endpoint}"
}