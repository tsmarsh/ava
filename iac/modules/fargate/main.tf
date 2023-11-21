provider "aws" {
  profile = var.aws_profile
  region     = var.aws_region
}

resource "aws_security_group" "ava_sg" {
  vpc_id = aws_vpc.ava_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc" "ava_vpc" {
  cidr_block = "10.0.0.0/16"
  // Other configurations like tags
}

resource "aws_subnet" "ava_subnet_1" {
  vpc_id            = aws_vpc.ava_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  // Other configurations
}

resource "aws_subnet" "ava_subnet_2" {
  vpc_id            = aws_vpc.ava_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  // Other configurations
}

resource "aws_ecs_cluster" "ava_cluster" {
  name = var.fargate_cluster_name
}


resource "aws_ecs_task_definition" "ava_tasks" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  container_definitions = jsonencode([
    {
      name  = var.docker_name
      image = var.docker_image
      ports = [
        {
          containerPort = var.docker_port
          hostPort      = var.docker_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ava_service" {
  name            = var.fargate_service_name
  cluster         = aws_ecs_cluster.ava_cluster.id
  task_definition = aws_ecs_task_definition.ava_tasks.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.ava_subnet_1.id, aws_subnet.ava_subnet_2.id]
    security_groups = [aws_security_group.ava_sg.id]
  }

  desired_count = 1

  // Other configurations like load balancer, service type, etc.
}

resource "aws_lb" "ava_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ava_sg.id]
  subnets            = [aws_subnet.ava_subnet_1.id, aws_subnet.ava_subnet_2.id]
}

resource "aws_lb_listener" "ava_listener" {
  load_balancer_arn = aws_lb.ava_alb.arn
  port              = var.docker_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ava_tg.arn
  }
}

resource "aws_lb_target_group" "ava_tg" {
  name     = "my-tg"
  port     = var.docker_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.ava_vpc.id
}

