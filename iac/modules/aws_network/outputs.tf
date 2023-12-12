output "sg_id" {
  value = aws_security_group.ava_sg.id
}

output "subnet_ids" {
  value = [aws_subnet.ava_subnet_1.id, aws_subnet.ava_subnet_2.id]
}

output "vpc_id" {
  value = aws_vpc.ava_vpc.id
}

output "lb_arn" {
  value = aws_lb_target_group.telegram_tg.arn
}