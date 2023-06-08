provider "aws" {
region = "us-east-2"
access_key = "AKIAZCOGWBPBJBGMR36I"
secret_key = "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"
}

resource "aws_instance" "my_ec2_instance" {
  ami                          = "ami-0430580de6244e02e"
  instance_type                = "t2.medium"
  key_name                     = "Ansible_key"
  associate_public_ip_address  = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
    usermod -aG docker ubuntu
  EOF

  tags = {
    Name = "Test_server"
  }
}
