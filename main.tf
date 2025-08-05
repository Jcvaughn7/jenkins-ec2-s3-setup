# --- Get default VPC ---
data "aws_vpc" "default" {
  default = true
}

# --- Security Group ---
resource "aws_security_group" "jenkins_sg_jv_luit" {
  name        = "jenkins_sg_jv_luit"
  description = "Allow SSH from my IP and Jenkins HTTP access"
  vpc_id      = data.aws_vpc.default.id

  # SSH from my IP only
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["166.137.19.12/32"]
  }

  # Jenkins port 8080
  ingress {
    description = "Allow Jenkins port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- EC2 Instance ---
resource "aws_instance" "jenkins_server_jv" {
  ami                    = "ami-08a6efd148b1f7504"
  instance_type          = "t2.micro"
  key_name               = "winserv"

  vpc_security_group_ids = [aws_security_group.jenkins_sg_jv_luit.id]
  user_data              = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins_server_jv"
  }
}

# --- S3 Bucket ---
resource "aws_s3_bucket" "jenkins_artifacts_jcv" {
  bucket = "jenkins-artifacts-jcv"

  tags = {
    Name        = "Jenkins_artifacts_jcv"
    Environment = "Dev"
  }
}

# --- S3 Bucket Block Public Access ---
resource "aws_s3_bucket_public_access_block" "jenkins_artifacts_jcv_block" {
  bucket = aws_s3_bucket.jenkins_artifacts_jcv.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
