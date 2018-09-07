variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "Our VPC to be configured"
}

variable "debug" {  default = "true"  }

variable "environment" {
  default = "scadalts"
  description = "Our environment description"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.50.0/24", "10.0.51.0/24"]
}

variable "availability_zones" {
  default = ["sa-east-1a", "sa-east-1c"]
}

variable "max_size" {
  default = "1"
}

variable "min_size" {
  default = "0"
}

variable "desired_capacity" {
  default = "1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "account" {
  default = "com.mnesis.tests"
  description = ""
}

variable "owner" {
  default = "katesclau@gmail.com"
  description = "Owner team email"
}
