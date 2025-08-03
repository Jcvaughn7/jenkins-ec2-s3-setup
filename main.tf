resource "aws_instance" "jenkins_server" {
  ami           = "ami-0c02fb55956c7d316" # Keep AMI ID, but can move to variable if desired
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = var.jenkins_sg_name
  description = "Allow Jenkins HTTP access and SSH"

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
