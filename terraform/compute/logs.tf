resource "aws_cloudwatch_log_group" "fe_log_group" {
  name              = "/ecs/fe-app"
  retention_in_days = 5

  tags = {
    Name = "fe-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "fe_log_stream" {
  name           = "fe-log-stream"
  log_group_name = aws_cloudwatch_log_group.fe_log_group.name
}

resource "aws_cloudwatch_log_group" "be_log_group" {
  name              = "/ecs/be-app"
  retention_in_days = 5

  tags = {
    Name = "be-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "be_log_stream" {
  name           = "be-log-stream"
  log_group_name = aws_cloudwatch_log_group.be_log_group.name
}