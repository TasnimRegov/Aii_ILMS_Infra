variable "region" {
    default = "us-east-1"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "availability_zone-a" {
    default = "us-east-1a"
}

variable "availability_zone-b" {
    default = "us-east-1b"
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