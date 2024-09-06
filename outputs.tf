output "azs" {
    value = slice(data.aws_availability_zones.azs.names, 0,2)
}

output "vpc_id" {
    value = aws_vpc.roboshop.id
  
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].vpc_id
  
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}


output "database_subnet_ids" {
  value = aws_subnet.database_subnet[*].id
}