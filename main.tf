provider "aws" {
region = "us-east-2"
access_key = "AKIAZCOGWBPBAFPD6KMF"
secret_key = "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"
}

locals {
  PRIVATE_IP = aws_instance.test_server.private_ip
}

resource "aws_instance" "test_server" {
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
    apt-get install ansible
    PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

    # Run Ansible playbook
    echo "Running Ansible playbook..."
    ansible-playbook -i ${aws_instance.test_server.private_ip}, /etc/ansible/ansible-playbook.yml
EOF
 
  tags = {
    Name = "Test_server"
  }
}
