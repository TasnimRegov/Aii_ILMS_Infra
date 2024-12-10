variable "region" {
    default = "us-east-1"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ami_id" {
    default = "ami-0f935a2ecd3a7bd5c"
}

variable "key_name" {
    default = "tasnim-test"
}






variable "public-sub" {
    description = "Public subnet"
    type = list(string)
    default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
}

variable "private-sub" {
    description = "Private subnet"
    type = list(string)
    default = [ "10.0.5.0/24","10.0.6.0/24","10.0.7.0/24" ]
}

variable "protected-sub" {
    description = "Protected subnet"
    type = list(string)
    default = [ "10.0.9.0/24","10.0.10.0/24","10.0.11.0/24" ]
}

variable "azs" {
    description = "Availability Zones"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "db-subnet-group" {
    default = "RDS-db-subnetgrp"
}

variable "db-name" {
    default = "tasnim-rds" 
}

variable "db-username" {
  default = "tasnim"
}

variable "db-password" {
  default = "regov112233"
}