resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_cluster" "ava_cluster" {
  name = var.fargate_cluster_name
}

resource "aws_ecs_task_definition" "ava_tasks" {
  family                   = "ava-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.docker_name
      image = var.docker_image
      ports = [
        {
          containerPort = var.docker_port
          hostPort      = var.telegram_port
        }
      ]

      environment_variables = {
        "MONGO_URI": var.mongo_uri
      }
    }
  ])
}

resource "aws_ecs_service" "ava_service" {
  name            = var.fargate_service_name
  cluster         = aws_ecs_cluster.ava_cluster.id
  task_definition = aws_ecs_task_definition.ava_tasks.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.sg_id]
  }

  load_balancer {
    target_group_arn = var.lb_arn
    container_name = var.docker_name
    container_port = var.telegram_port
  }
  desired_count = 1
}