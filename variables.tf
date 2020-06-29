variable "name" {
    default = "Kintel"
    description = "Deployment for CPE log telemetry analytics"
}

variable "aws_access_key" {
    type = string
    description = "The access key used for deployment, to be loaded form .tfvars or stroed credentials in env"
}

variable "aws_secret_key" {
    type = string
    description = "The secret key used for deployment, to be loaded form .tfvars or stroed credentials in env"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR block defined for the network"
}

variable "region" {
    type = string
    description = "The deployment region"
}

variable "subnet_bits" {
    type = string
    description = "Subnet bits"
}

variable "vpc_name" {
    type = string
    description = "VPC name"
}

