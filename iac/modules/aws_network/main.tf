resource "aws_security_group" "ava_sg" {
  vpc_id = aws_vpc.ava_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
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
}

resource "aws_internet_gateway" "ava_igw" {
  vpc_id = aws_vpc.ava_vpc.id
  tags = {
    Name = "ava-internet-gateway"
  }
}

resource "aws_route_table" "ava_rt" {
  vpc_id = aws_vpc.ava_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ava_igw.id
  }

  tags = {
    Name = "ava-route-table"
  }
}

resource "aws_route_table_association" "ava_rta_subnet_1" {
  subnet_id      = aws_subnet.ava_subnet_1.id
  route_table_id = aws_route_table.ava_rt.id
}

resource "aws_route_table_association" "ava_rta_subnet_2" {
  subnet_id      = aws_subnet.ava_subnet_2.id
  route_table_id = aws_route_table.ava_rt.id
}

resource "aws_lb" "ava_alb" {
  name               = "ava-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ava_sg.id]
  subnets            = [aws_subnet.ava_subnet_1.id, aws_subnet.ava_subnet_2.id]
}

resource "aws_lb_listener" "ava_listener" {
  load_balancer_arn = aws_lb.ava_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.telegram_tg.arn
  }
}

resource "aws_lb_target_group" "telegram_tg" {
  name     = "ava-tg"
  port     = var.telegram_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.ava_vpc.id
}