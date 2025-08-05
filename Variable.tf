variable "aws_region" {
    description = "AWS region to deploy resources in"
    type        = string
    default     = "us-east-1"
}

variable "key_name" {
    description = "Name of the EC2 Key Pair"
    type        = string 
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "S3 bucket name for Jenkins artifacts"
  type        = string
  default     = "myproject-bucket-instance"
}

variable "jenkins_sg_name" {
  description = "The name of the Jenkins security group"
  type        = string
  default     = "jenkins_sg_demo_v2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "my_ip" {
  description = "Your IP address with CIDR notation"
  type        = string
}
