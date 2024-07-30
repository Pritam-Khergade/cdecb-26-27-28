output "vpcid" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value = aws_subnet.public[0].id
}
output "private_subnet_id" {
  value = aws_subnet.private[*].id
}