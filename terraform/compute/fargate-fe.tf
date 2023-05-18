resource "aws_ecs_cluster" "fe_main_cluster" {
  name = "${var.deploy_name}-fe-cluster"
}

resource "aws_ecs_task_definition" "fe_main_taskdefinition" {
  family                   = "${var.deploy_name}-task-family-fe"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role_fe.arn
  task_role_arn            = aws_iam_role.ecs_task_role_fe.arn
  container_definitions = jsonencode([
    {
      name      = "${var.deploy_name}-container-fe"
      image     = "187673000188.dkr.ecr.us-east-1.amazonaws.com/webapp:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name = "backendDns"
          value = var.private_lb_dns
        }
      ]
      logConfiguration = {
        logDriver: "awslogs"
        options = {
          awslogs-group: "/ecs/fe-app",
          awslogs-region: "us-east-1",
          awslogs-stream-prefix: "fe-fargate"
        }
      }  
    }
  ])
}

resource "aws_iam_role" "ecs_task_execution_role_fe" {
  name = "${var.deploy_name}-ecsTaskExecutionRole-fe"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_fe_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role_fe.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role_fe" {
  name = "${var.deploy_name}-ecsTaskRole-fe"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "ecs_task_role_fe_policy" {
  name        = "${var.deploy_name}-ecsTaskRole-policy-fe"
  description = "Policy that deny access to AWS"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Deny",
           "Action": [
               "*"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs_task_role_fe_policy_attachment" {
  role       = aws_iam_role.ecs_task_role_fe.name
  policy_arn = aws_iam_policy.ecs_task_role_fe_policy.arn
}

resource "aws_ecs_service" "fe_main_service" {
  name                               = "${var.deploy_name}-service-fe"
  cluster                            = aws_ecs_cluster.fe_main_cluster.id
  task_definition                    = aws_ecs_task_definition.fe_main_taskdefinition.id
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [var.public_sg_id]
    subnets          = [var.public_subnet_id_a, var.public_subnet_id_b]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.public_lb_tg_id
    container_name   = "${var.deploy_name}-container-fe"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}