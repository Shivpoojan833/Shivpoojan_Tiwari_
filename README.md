# AWS Cloud Assessment Submission
**Name:** Shivpoojan
**Project:** Flentas Cloud Trainee Assessment

---

## 📂 Project Overview
This repository contains the Infrastructure as Code (Terraform) and documentation for the 5 assigned AWS tasks. I have organized the code into separate folders for clarity.

**Repository Structure:**
* `Task_1/` - VPC & Networking setup
* `Task_2/` - Static Website on EC2 (Nginx)
* `Task_3/` - Load Balancer & Auto Scaling (High Availability)
* `Task_4/` - Billing Alarms
* `Task_5/` - Architecture Diagram

---

## 🛠 Task 1: Networking & Subnetting

### My Approach
For the network foundation, I decided to build a custom VPC from scratch rather than relying on the default one. I wanted a clean separation between the public layer (for the Load Balancer/NAT) and the private layer (for backend servers).

I configured a **NAT Gateway** in the public subnet so that my private instances can still download updates from the internet without exposing themselves to inbound attacks.

### IP Range Choices
* **VPC (`10.0.0.0/16`):** I went with a standard `/16` block. It gives me over 65,000 IPs, which is more than enough for this project and leaves plenty of room if I needed to add more subnets later.
* **Subnets (`10.0.1.0/24`, `10.0.2.0/24`...):** I used `/24` for the subnets because it’s the industry standard—it provides 256 IPs per subnet, which is easy to manage and calculate.

**Screenshots:**
* **VPC Dashboard:** ![VPC](./screenshots/task1_vpc.png)
* **Subnet List:** ![Subnets](./screenshots/task1_subnets.png)
* **Route Tables:** ![Route Tables](./screenshots/task1_routes.png)
* **NAT & IGW:** ![NAT](./screenshots/task1_nat.png)

---

## 🚀 Task 2: EC2 Static Website Hosting

### How I Built It
For this task, I needed a simple way to host my resume. I chose **Nginx** because it's lightweight and easy to configure.

To automate the process, I wrote a `user_data` script in Terraform. This script runs as soon as the instance launches, updates the system, installs Nginx, and generates my HTML resume file. This means I didn't have to SSH into the server manually to set anything up—it just works out of the box.

### Security Hardening
I followed the "Least Privilege" principle for the Security Group:
1.  **Port 80 (HTTP):** Open to the world so people can see the website.
2.  **Port 22 (SSH):** Open for management.
3.  **Everything else:** Blocked.

**Screenshots:**
* **Running Instance:** ![EC2](./screenshots/task2_ec2.png)
* **Security Group Rules:** ![Security Group](./screenshots/task2_sg.png)
* **Live Website:** ![Website](./screenshots/task2_website.png)

---

## ⚖️ Task 3: High Availability & Auto Scaling

### Architecture Logic
Moving to a High Availability setup meant I had to ensure the app wouldn't crash if one server or zone failed. I deployed the infrastructure across two Availability Zones in the Sydney region.

* **Traffic Flow:** Users hit the Application Load Balancer (ALB) first.
* **Security:** I moved the EC2 instances into **Private Subnets**. This is a crucial security step—it means no one on the internet can directly ping the servers. The ALB handles the public traffic and forwards it internally.
* **Scaling:** I attached an Auto Scaling Group (ASG) to keep the app resilient. If traffic spikes, it adds servers; if it drops, it removes them to save money.

**Screenshots:**
* **Load Balancer:** ![ALB](./screenshots/task3_alb.png)
* **Target Group Status:** ![Target Group](./screenshots/task3_tg.png)
* **Auto Scaling Group:** ![ASG](./screenshots/task3_asg.png)
* **Private Instances:** ![Instances](./screenshots/task3_instances.png)

---

## 💰 Task 4: Billing & Cost Monitoring

### Why This Matters
Since I am using my personal AWS Free Tier account, cost monitoring was actually the first thing I thought about. It's easy to accidentally leave a NAT Gateway or a large EC2 instance running, which can rack up a huge bill overnight.

I set up a CloudWatch alarm to trigger if my estimated charges go over ₹100. This acts as a safety net so I can react immediately if I forget to delete a resource.

**Screenshots:**
* **Billing Alarm:** ![Alarm](./screenshots/task4_alarm.png)
* **Free Tier Alerts:** ![Free Tier](./screenshots/task4_freetier.png)

---

## 📐 Task 5: Architecture Diagram (10k Users)

### Design Strategy
To support 10,000 concurrent users, a single server wouldn't survive. I designed a **3-Tier Architecture** focused on redundancy and caching:

1.  **Frontend:** I placed AWS WAF (Web Application Firewall) at the edge to block malicious traffic before it even hits our network.
2.  **Caching:** I added **ElastiCache (Redis)**. By caching frequently accessed data (like user sessions), we reduce the load on the main database significantly.
3.  **Database:** I chose **Amazon Aurora** with a Multi-AZ standby. If the primary database fails, the standby takes over automatically without data loss.

### Architecture Diagram
![Architecture Diagram](./screenshots/task5_diagram.png)

---
