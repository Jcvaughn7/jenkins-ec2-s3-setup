data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and Jenkins HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow Jenkins port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["75.189.59.32/32"]  # Replace with your public IP if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_project_EC2" {
  ami           = "ami-0ad253013fad0a42a"
  instance_type = "t2.micro"
  key_name      = "winserv"
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install java-openjdk11 -y
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              yum install jenkins git -y
              systemctl enable jenkins
              systemctl start jenkins
            EOF

  tags = {
    Name = "ProjectInstance"
  }
}


resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = "myproject-bucket-instance"
}

resource "aws_s3_bucket_public_access_block" "jenkins_public_access_block" {
  bucket                  = aws_s3_bucket.jenkins_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
