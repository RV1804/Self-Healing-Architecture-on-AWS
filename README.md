Self-Healing Infrastructure on AWS with Terraform
This project showcases how to deploy a resilient, self-healing infrastructure on Amazon Web Services (AWS) using Terraform. The goal is to automate cloud resource provisioning and ensure high availability through automatic recovery of failed components.

🔍 Project Summary
The system is designed to run across multiple availability zones, using Terraform scripts to create and manage resources like VPCs, subnets, EC2 instances, load balancers, and auto scaling groups. It ensures that if an instance fails, a new one is automatically launched to maintain uptime.

🧰 Tools & Services Used
-  Terraform – Infrastructure as Code (IaC) tool for automating deployments
-  AWS EC2 – Virtual server instances
-  VPC & Subnets – Custom network setup
-  Auto Scaling Groups (ASG) – For automatic recovery and scaling
-  Load Balancer (ALB) – Distributes incoming traffic across instances

📁 Project Files
main.tf – Main configuration for AWS resources
variables.tf – Input variables used across the project
README.md – Project documentation
.gitignore – Excluded files and folders for Git

⚙️ Setup Instructions
Prerequisites:
-  AWS CLI configured with appropriate credentials
-  Terraform installed and working
-  AWS account with access to EC2, VPC, IAM, and Auto Scaling

To Deploy:
1.	Clone this repository:
   git clone https://github.com/RV1804/Self-Healing-Architecture-on-AWS.git
   cd your-repo-name
2.	Initialize Terraform:
   terraform init
3.	Review the plan:
   terraform plan
4.	Deploy the infrastructure:
   terraform apply
5.	Destroy the setup (optional):
   terraform destroy

✅ Key Features
-  Fully automated AWS resource provisioning
-  High availability via multi-AZ configuration
-  Self-healing EC2 instances using Auto Scaling
-  Load balancing to manage incoming traffic
-  Scalable and secure design for production-like environments

📌 Requirements

Functional:
-  Host a web app on AWS
-  Provision VPC, subnets, EC2, ALB, ASG using Terraform

Non-Functional:
-  High scalability and reliability
-  Security best practices
-  Easy to maintain and extend
-  Efficient use of cloud resources

📚 References
-  Terraform Official Docs: https://www.terraform.io/docs
-  AWS Documentation: https://docs.aws.amazon.com/
-  Course Material: Infrastructure Automation with Terraform

👨‍💻 Author
Raj Vaghasiya
Mentor: Prof. Abrar Qureshi
Spring 2025 Research Project – GRAD 695
