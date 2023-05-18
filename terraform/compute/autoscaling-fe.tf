resource "aws_appautoscaling_target" "fe_autoscale_target" {
  max_capacity = 4
  min_capacity = 2
  resource_id = "service/${aws_ecs_cluster.fe_main_cluster.name}/${aws_ecs_service.fe_main_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "fe_autoscale_policy_mem" {
  name               = "fe-autoscale-policy-mem"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.fe_autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.fe_autoscale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.fe_autoscale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "fe_autoscale_policy_cpu" {
  name = "fe-autoscale-policy-cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.fe_autoscale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.fe_autoscale_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.fe_autoscale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
}