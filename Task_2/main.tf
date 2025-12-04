provider "aws"{
  region = "ap-southeast-2" # Sydney
}

locals{
  name_prefix = "Shivpoojan_Tiwari" 
}
data "aws_vpc" "default"{
  default = true
}
resource "aws_security_group" "resume_sg" {
  name        = "${local.name_prefix}_Resume_SG"
  description = "Allow HTTP and SSH only"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH"
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
  
  tags = { Name = "${local.name_prefix}_Resume_SG" }
}
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
resource "aws_instance" "resume_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro" 
  
  vpc_security_group_ids = [aws_security_group.resume_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              
              # Create a simple Resume HTML file
              cat <<EOT > /usr/share/nginx/html/index.html
            
              <html>
              <head>
                  <title>Resume | Shivpoojan</title>
                  <style>
                      body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f9; color: #333; margin: 0; padding: 0; }
                      .container { max-width: 800px; margin: 50px auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
                      h1 { color: #2c3e50; text-align: center; margin-bottom: 10px; }
                      h3 { color: #16a085; text-align: center; margin-top: 0; font-weight: 400; }
                      .section { margin-bottom: 20px; }
                      .label { font-weight: bold; color: #555; }
                      hr { border: 0; height: 1px; background: #ddd; margin: 20px 0; }
                      .footer { text-align: center; font-size: 0.8em; color: #888; margin-top: 40px; }
                      .tag { background: #e0f2f1; color: #00695c; padding: 5px 10px; border-radius: 4px; display: inline-block; margin: 2px; font-size: 0.9em; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>Shivpoojan Tiwari</h1>
                      <h3>Cloud Trainee & DevOps Enthusiast</h3>
                      <hr>
                      
                      <div class="section">
                          <p class="label">Contact Info:</p>
                          <p>&#9993; mvmoraishivpujan12b@gmail.com</p>
                      </div>

                      <div class="section">
                          <p class="label">Technical Skills:</p>
                          <div>
                              <span class="tag">AWS Cloud</span>
                              <span class="tag">Terraform</span>
                              <span class="tag">Linux Administration</span>
                              <span class="tag">Java Programming</span>
                              <span class="tag">Cybersecurity</span>
                          </div>
                      </div>

                      <div class="section">
                          <p class="label">Professional Summary:</p>
                          <p>Aspiring Cloud practicioner with a foundation in AWS infrastructure, Infrastructure as Code (IaC), and secure system design. Passionate about automating deployments and building resilient cloud architectures.</p>
                      </div>

                      <div class="footer">
                          <p>Hosted on AWS EC2 (t2.micro) | Deployed by Terraform</p>
                      </div>
                  </div>
              </body>
              </html>
              EOT
              EOF

  tags = { Name = "${local.name_prefix}_Resume_App" }
}
output "website_url" {
  value = "http://${aws_instance.resume_server.public_ip}"
}