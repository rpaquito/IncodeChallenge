resource "aws_ecs_cluster" "be_main_cluster" {
  name = "${var.deploy_name}-be-cluster"
}

resource "aws_ecs_task_definition" "be_main_taskdefinition" {
  family                   = "${var.deploy_name}-task-family-be"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role_be.arn
  task_role_arn            = aws_iam_role.ecs_task_role_be.arn
  container_definitions = jsonencode([
    {
      name      = "${var.deploy_name}-container-be"
      image     = "187673000188.dkr.ecr.us-east-1.amazonaws.com/backend:latest"
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
          name = "db_username"
          value = var.db_username
        },
        {
          name = "db_password"
          value = var.db_password
        },
        {
          name = "db_endpoint"
          value = var.db_endpoint
        }
      ]      
      logConfiguration = {
        logDriver: "awslogs"
        options = {
          awslogs-group: "/ecs/be-app",
          awslogs-region: "us-east-1",
          awslogs-stream-prefix: "be-fargate"
        }
      }      
    }
  ])
}

resource "aws_iam_role" "ecs_task_execution_role_be" {
  name = "${var.deploy_name}-ecsTaskExecutionRole-be"

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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_be_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role_be.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role_be" {
  name = "${var.deploy_name}-ecsTaskRole-be"

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

resource "aws_iam_policy" "ecs_task_role_be_policy" {
  name        = "${var.deploy_name}-ecsTaskRole-policy-be"
  description = "Policy that allows access to AWS rds"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "rds:*"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs_task_role_be_policy_attachment" {
  role       = aws_iam_role.ecs_task_role_be.name
  policy_arn = aws_iam_policy.ecs_task_role_be_policy.arn
}

resource "aws_ecs_service" "be_main_service" {
  name                               = "${var.deploy_name}-service-be"
  cluster                            = aws_ecs_cluster.be_main_cluster.id
  task_definition                    = aws_ecs_task_definition.be_main_taskdefinition.id
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [var.private_sg_id]
    subnets          = [var.private_subnet_id_a, var.private_subnet_id_b]
  }

  load_balancer {
    target_group_arn = var.private_lb_tg_id
    container_name   = "${var.deploy_name}-container-be"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}