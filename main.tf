provider "aws" {
region = "us-east-2"
}

#locals {
 # PRIVATE_IP = aws_instance.test_server.private_ip
#}

resource "aws_instance" "test_server" {
  ami                          = "ami-0430580de6244e02e"
  instance_type                = "t2.medium"
  key_name                     = "Insure_key"
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
    sudo docker run -p 8084:8081 -d harshithaanand/finance_me_conatiner
    sudo apt-get install prometheus

    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y software-properties-common wget
    sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
    echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
    echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
    sudo apt-get install grafana
    sudo apt-get install grafana-enterprise

EOF
 
  tags = {
    Name = "Production_Server"
  }
}
