output "private_subnets_id_list" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnets_id_list" {
  value = aws_subnet.public_subnets[*].id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}