# AWS Cloud Assessment Submission
**Name:** Shivpoojan
**Project:** Flentas Cloud Trainee Assessment

---

## 📂 Project Overview
This repository contains the Infrastructure as Code (Terraform) and documentation for the 5 assigned AWS tasks.

**Repository Structure:**
![Repo Structure](./Screenshots/Screenshot%202025-12-04%20223727.png)

* `Task_1/` - VPC & Networking setup
* `Task_2/` - Static Website on EC2 (Nginx)
* `Task_3/` - Load Balancer & Auto Scaling (High Availability)
* `Task_4/` - Billing Alarms
* `Task_5/` - Architecture Diagram

---

## 🛠 Task 1: Networking & Subnetting

### My Approach
For the network foundation, I built a custom VPC with a clean separation between the public layer (for the Load Balancer/NAT) and the private layer (for backend servers). I configured a **NAT Gateway** in the public subnet so private instances can download updates securely without being exposed to the public internet.

*(Note: Terraform code for the VPC setup is included in the `Task_1` folder)*

---

## 🚀 Task 2: EC2 Static Website Hosting

### How I Built It
I hosted my resume using **Nginx** on a `t2.micro` instance. I used a Terraform `user_data` script to automate the installation and HTML generation, so the server is ready the moment it launches.

### Security Hardening
I followed "Least Privilege" for the Security Group, opening only Port 80 (HTTP) and Port 22 (SSH).

**Screenshots:**
* **Terraform Output (Instance Creation):**
  ![Terraform Output](./Screenshots/Screenshot%202025-12-04%20205522.png)
* **Live Website Proof:**
  ![Resume Website](./Screenshots/Screenshot%202025-12-04%20205430.png)

---

## ⚖️ Task 3: High Availability & Auto Scaling

### Architecture Logic
To ensure high availability, I deployed resources across two Availability Zones in the Sydney region.
* **Traffic Flow:** Users hit the Application Load Balancer (ALB) first.
* **Security:** Backend EC2 instances run in **Private Subnets**, safe from direct internet access.
* **Scaling:** An Auto Scaling Group (ASG) monitors load and maintains instance health.

**Screenshots:**
* **Load Balancer Configuration:**
  ![ALB Details](./Screenshots/Screenshot%202025-12-04%20211101.png)
* **Target Group Health (Healthy Hosts):**
  ![Target Group](./Screenshots/Screenshot%202025-12-04%20211046.png)
* **Auto Scaling Group Capacity:**
  ![ASG Status](./Screenshots/Screenshot%202025-12-04%20211147.png)
* **High Availability App Proof (Served via Internal IP):**
  ![App Proof](./Screenshots/Screenshot%202025-12-04%20211533.png)

---

## 💰 Task 4: Billing & Cost Monitoring

### Why This Matters
Since I am using the Free Tier, cost monitoring is my safety net. I configured a CloudWatch alarm to trigger if charges exceed ₹100, preventing accidental bills from zombie resources like unattached EBS volumes.

**Screenshots:**
* **Billing Alarm Graph (>₹100):**
  ![Billing Alarm](./Screenshots/Screenshot%202025-12-04%20213256.png)
* **Free Tier Alerts Configured:**
  ![Alert Preferences](./Screenshots/Screenshot%202025-12-04%20213631.png)

---

## 📐 Task 5: Architecture Diagram (10k Users)

### Design Strategy
I designed a **3-Tier Architecture** to support 10,000 users:
1.  **Frontend:** AWS WAF + ALB for secure traffic distribution.
2.  **App Layer:** Auto Scaling Group for handling traffic spikes.
3.  **Data Layer:** ElastiCache (Redis) to offload database reads and Aurora Multi-AZ for database redundancy.

*(Note: Architecture diagram source file/image can be found in the `Task_5` folder)*

---
