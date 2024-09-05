locals {
  Name = "${var.project_name}-${var.environment}"
}

locals {
  aznames = slice(data.aws_availability_zones.azs.names, 0,2)
}