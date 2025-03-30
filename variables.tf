variable "profile" {
  description = "AWS credentials Profile"
  default= "Terraform_Nagios"
}

variable "region" {
  description = "AWS region to create VPC"
  default     = "ap-south-1"
}

variable "az"{
  description = "Availability Zones for Public and Private Subnets"
  default = ["ap-south-1a","ap-south-1b"]
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/25"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "Terraform_VPC"
}

variable "public_subnets_cidr_blocks" {
  description = "CIDR blocks of Public Subnets"
  default     = ["10.0.0.0/27", "10.0.0.64/27"]
}

variable "private_subnets_cidr_blocks" {
  description = "CIDR blocks of Private Subnets"
  default     = ["10.0.0.32/27", "10.0.0.96/27"]
}

variable "NagiosServer_ami" {
  description = "AMI for Nagios Server"
  default     = "ami-09b0c3758dc627648"
  //ami-06b5098f383ba4f31 was used earlier
}

variable "NagiosClient_ami" {
  description = "AMI for Nagios Client"
  default     = "ami-03d58dc9aff1a46b0"
}

variable "Nagios_instance" {
  description = "Instance type of Nagios Server"
  default     = "t2.micro"
}

variable "NagiosServer_name" {
  description = "Name of Nagios Servers"
  default     = "Nagios Server on Terraform_VPC"
}

variable "NagiosClient_name" {
  description = "Name of Nagios Clients"
  default     = "Node "
}

variable "PublicRTName"{
  description = "Public Route Table Name"
  default = "PublicRT"
}

variable "PrivateRTName"{
  description = "Private Route Table Name"
  default ="PrivateRT"
}

variable "VPCIGWName"{
  description = "Name for VPC Internet Gateway"
  default = "TerraformVPCIGW"
}

variable "VPCNATName"{
  description = "Name for VPC NAT Gateway"
  default = "TerraformNAT"
}

variable "EIPName"{
  description = "Name for VPC NAT Elastic IP"
  default = "EIP for NAT"
}

variable "NagiosServerPrivateIP"{
  description = "Private IP for Nagios Server"
  default = "10.0.0.6"
}



variable "NagiosClientPrivateIPs"{
  description = "Private IP Addresses for EC2 Instances"
  default = ["10.0.0.10","10.0.0.11","10.0.0.12","10.0.0.13","10.0.0.14","10.0.0.15","10.0.0.16","10.0.0.17","10.0.0.18","10.0.0.19","10.0.0.20","10.0.0.21","10.0.0.22","10.0.0.23","10.0.0.24","10.0.0.25","10.0.0.26","10.0.0.27","10.0.0.28","10.0.0.69","10.0.0.70","10.0.0.71","10.0.0.72","10.0.0.73","10.0.0.74","10.0.0.75","10.0.0.76","10.0.0.77","10.0.0.78","10.0.0.79","10.0.0.80","10.0.0.81","10.0.0.82","10.0.0.83","10.0.0.84","10.0.0.85","10.0.0.86","10.0.0.87","10.0.0.88","10.0.0.89","10.0.0.90","10.0.0.91","10.0.0.92","10.0.0.93"]
}

variable "anywhere"{
  description = "CIDR ENTRY FOR ANYWHERE i.e 0.0.0.0/0"
  default = "0.0.0.0/0"
}

variable "node_count"{
  description = "Node / Client Count"
  default = 2
}

variable "key_file_dir"{
  default="H:/Raj Vaghasiya/8th Sem INTERNSHIP/Project Files/PEM Keys/"
}