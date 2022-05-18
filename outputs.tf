output "arn" {
  description = "The ARN of the instance."
  value       = aws_instance.this.arn
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance."
  value       = aws_instance.this.capacity_reservation_specification
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to."
  value       = aws_instance.this.outpost_arn
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface."
  value       = aws_instance.this.primary_network_interface_id
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.this.private_dns
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip as this field will change after the EIP is attached."
  value       = element(concat(aws_eip.this[*].public_ip, [""]), 0)
}

output "private_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip as this field will change after the EIP is attached."
  value       = element(concat(aws_eip.this[*].private_ip, [""]), 0)
}

output "security_group_id" {
  description = "ID of the security group associated to this ec2"
  value       = try(aws_security_group.this[0].id, "")
}

output "security_group_arn" {
  description = "ARN of the security group associated to this ec2"
  value       = try(aws_security_group.this[0].arn, "")
}
