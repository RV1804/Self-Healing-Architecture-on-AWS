provider "aws" {
    profile = var.profile
    region = var.region
  
}

resource "aws_vpc" "TerraformVPC"{
    cidr_block=var.vpc_cidr_block
    enable_dns_support=true
    enable_dns_hostnames=true

    tags={
        Name=var.vpc_name
    }
}

resource "aws_subnet" "publicSubnet1"{
    vpc_id=aws_vpc.TerraformVPC.id
    cidr_block=var.public_subnets_cidr_blocks[0]
    availability_zone = var.az[0]

    tags={
        Name="publicSubnet1"
    }
}

resource "aws_subnet" "privateSubnet1"{
    vpc_id=aws_vpc.TerraformVPC.id
    cidr_block=var.private_subnets_cidr_blocks[0]
    availability_zone = var.az[0]

    tags={
        Name="privateSubnet1"
    }
}

resource "aws_subnet" "publicSubnet2"{
    vpc_id=aws_vpc.TerraformVPC.id
    cidr_block=var.public_subnets_cidr_blocks[1]
    availability_zone = var.az[1]

    tags={
        Name="publicSubnet2"
    }
}

resource "aws_subnet" "privateSubnet2"{
    vpc_id=aws_vpc.TerraformVPC.id
    cidr_block=var.private_subnets_cidr_blocks[1]
    availability_zone = var.az[1]

    tags={
        Name="privateSubnet2"
    }
}

resource "aws_route_table" "privateRT"{
    vpc_id=aws_vpc.TerraformVPC.id

    tags={
        Name=var.PrivateRTName
    }
}

resource "aws_route_table_association" "publicSubnet1"{
    subnet_id=aws_subnet.publicSubnet1.id
    route_table_id=aws_vpc.TerraformVPC.default_route_table_id
}

resource "aws_route_table_association" "publicSubnet2"{
    subnet_id=aws_subnet.publicSubnet2.id
    route_table_id=aws_vpc.TerraformVPC.default_route_table_id
}

resource "aws_route_table_association" "privateSubnet1"{
    subnet_id=aws_subnet.privateSubnet1.id
    route_table_id=aws_route_table.privateRT.id
}

resource "aws_route_table_association" "privateSubnet2"{
    subnet_id=aws_subnet.privateSubnet2.id
    route_table_id=aws_route_table.privateRT.id
}

resource "aws_internet_gateway" "TerraformVPCIGW"{
    vpc_id=aws_vpc.TerraformVPC.id
    
    tags={
        Name=var.VPCIGWName
    }
}

resource "aws_route" "PubToIGW"{
    route_table_id=aws_vpc.TerraformVPC.default_route_table_id
    destination_cidr_block=var.anywhere
    gateway_id=aws_internet_gateway.TerraformVPCIGW.id
}

resource "aws_eip" "nat"{
    domain="vpc"
    tags={
        Name=var.EIPName
    }
}

resource "aws_nat_gateway" "TerraformVPCNAT"{
    allocation_id=aws_eip.nat.id
    subnet_id=aws_subnet.publicSubnet1.id
    depends_on = [aws_instance.Nagios_Client]
    #private_ip="10.0.0.9"
    tags={
        Name=var.VPCNATName
    }
}


resource "aws_route" "PrivateToNAT"{
    route_table_id=aws_route_table.privateRT.id
    destination_cidr_block=var.anywhere
    nat_gateway_id=aws_nat_gateway.TerraformVPCNAT.id
}

resource "aws_security_group" "Nagios_NEW" {
  name        = "NAGIOS_NEW"
  description = "NAGIOS NEW SEC GROUP"
  vpc_id      = aws_vpc.TerraformVPC.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom UDP"
    from_port   = 161
    to_port     = 161
    protocol    = "udp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom UDP"
    from_port   = 162
    to_port     = 162
    protocol    = "udp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom TCP"
    from_port   = 161
    to_port     = 161
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom TCP"
    from_port   = 162
    to_port     = 162
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom UDP"
    from_port   = 5666
    to_port     = 5666
    protocol    = "udp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "Custom TCP"
    from_port   = 5666
    to_port     = 5666
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "ALL ICMP IPv4"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.anywhere]
  }

  ingress{
    description = "ALL ICMP IPv6"
    from_port   = -1
    to_port     = -1
    protocol    = "icmpv6"
    cidr_blocks = [var.anywhere]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere]
  }

  tags = {
    Name = "NAGIOS_TERRAFORM"
  }
}

resource "aws_security_group" "ALB_Sec_Grp" {
  description = "Allow worker nodes pods to communicate with outsiders"
  vpc_id      = aws_vpc.TerraformVPC.id
  name        = "ALB_SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      description = "HTTP"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [var.anywhere]
  }

  ingress {
      description = "HTTPS"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [var.anywhere]
  }

  tags = {
    Name = "ALB_Terraform_SG"
  }
}

resource "aws_lb" "ALB_Terraform_VPC" {
  name               = "alb-terraform-vpc"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_Sec_Grp.id]
  subnets            = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]
  tags = {
    Environment = "Development"
  }
}

resource "aws_lb_target_group" "Nagios_TG" {
  name        = "alb-nagios-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.TerraformVPC.id
}

resource "aws_lb_target_group_attachment" "NagiosServer_TG" {
  target_group_arn = aws_lb_target_group.Nagios_TG.arn
  target_id        = aws_instance.Nagios_Server.private_ip
  port             = 80
}

resource "aws_lb_target_group" "Node_TG" {
  name        = "alb-node-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.TerraformVPC.id
}

resource "aws_lb_target_group_attachment" "NodesALL_TG" {
  count=var.node_count
  target_group_arn = aws_lb_target_group.Node_TG.arn
  target_id        = aws_instance.Nagios_Client[count.index].private_ip
  port             = 80
}


resource "aws_lb_listener" "ALB_Listener" {
  load_balancer_arn = aws_lb.ALB_Terraform_VPC.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Node_TG.arn
  }
}

resource "aws_lb_listener_rule" "NagiosForward" {
  listener_arn = aws_lb_listener.ALB_Listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Nagios_TG.arn
  }

  condition {
    path_pattern {
      values = ["*nagios*"]
    }
  }
}

resource "aws_instance" "Nagios_Server"{
    ami=var.NagiosServer_ami
    instance_type=var.Nagios_instance
    subnet_id=aws_subnet.publicSubnet1.id
    private_ip=var.NagiosServerPrivateIP
    associate_public_ip_address=true
    key_name="Nagios_server"
    security_groups=[aws_security_group.Nagios_NEW.id]

    provisioner "remote-exec" {
        inline = [
            "sudo bash -f /usr/local/fetch_config.sh ${var.node_count}",
            "sudo systemctl restart apache2.service",
            "sudo systemctl restart nagios.service",
            ]

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file("${var.key_file_dir}Nagios_server.pem")
            host = aws_instance.Nagios_Server.public_ip
            agent=false
        }
    }
    
    tags={
        Name=var.NagiosServer_name
    }

}

resource "aws_instance" "Nagios_Client"{
    count=var.node_count
    ami=var.NagiosClient_ami
    instance_type=var.Nagios_instance
    subnet_id=aws_subnet.publicSubnet1.id
    private_ip=var.NagiosClientPrivateIPs[count.index]
    associate_public_ip_address=true
    key_name="Nagios Client"
    security_groups=[aws_security_group.Nagios_NEW.id]

    provisioner "remote-exec" {
        inline = [
        //"sudo sh -c \"sed -i 's/SERVER_PRIVATE_IP_HERE/${self.private_ip}/g' /usr/local/nagios/etc/nrpe.cfg\"",
        "sudo sh -c \"sed -i 's/172.31.1.26/10.0.0.6/g' /usr/local/nagios/etc/nrpe.cfg\"",
        "sudo systemctl restart nrpe.service",
        ]

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file("${var.key_file_dir}Nagios Client.pem")
            host = self.public_ip
            agent=false
        }
    }
    
    tags={
        Name= "${var.NagiosClient_name} ${count.index}"
    }

}
resource "aws_launch_template" "NagiosClientLT" {
  name_prefix   = "nagios-client-"
  image_id      = var.NagiosClient_ami
  instance_type = var.Nagios_instance
  key_name      = "Nagios Client"
  vpc_security_group_ids = [aws_security_group.Nagios_NEW.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Nagios Client"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
              aws ec2 create-tags --resources $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=NagiosClientASG-$PRIVATE_IP
              #!/bin/bash
              sudo sh -c "sed -i 's/172.31.1.26/10.0.0.6/g' /usr/local/nagios/etc/nrpe.cfg"
              sudo systemctl restart nrpe.service
              EOF
            )
}

resource "aws_lb" "NagiosLB" {
  name               = "Nagios-LB"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.Nagios_NEW.id]
  subnets             = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]
}

resource "aws_lb_target_group" "NagiosTG" {
  name     = "Nagios-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.TerraformVPC.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "NagiosListener" {
  load_balancer_arn = aws_lb.NagiosLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NagiosTG.arn
  }
}

resource "aws_autoscaling_group" "NagiosClientsASG" {
  desired_capacity     = 2
  max_size             = 20
  min_size             = 1

  vpc_zone_identifier  = [aws_subnet.privateSubnet1.id, aws_subnet.privateSubnet2.id]
  launch_template {
    id      = aws_launch_template.NagiosClientLT.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.NagiosTG.arn]

  tag {
    key                 = "Name"
    value = "NagiosClientASG"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "NagiosScaleOut" {
  name                   = "NagiosScaleOutPolicy"
  autoscaling_group_name = aws_autoscaling_group.NagiosClientsASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 2
  cooldown               = 300
}

resource "aws_autoscaling_policy" "NagiosScaleIn" {
  name                   = "NagiosScaleInPolicy"
  autoscaling_group_name = aws_autoscaling_group.NagiosClientsASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -2
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "HighCPU" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period = 30
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.NagiosScaleOut.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.NagiosClientsASG.name
  }
}

resource "aws_cloudwatch_metric_alarm" "LowCPU" {
  alarm_name          = "LowCPUUtilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period = 30
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [aws_autoscaling_policy.NagiosScaleIn.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.NagiosClientsASG.name
  }
}

resource "aws_ssm_parameter" "nagios_server_ip" {
  name        = "/nagios/server_ip"
  description = "Nagios Server Public IP"
  type        = "String"
  value       = aws_instance.Nagios_Server.public_ip
}


output "AutoScalingGroupName" {
  value = aws_autoscaling_group.NagiosClientsASG.name
}

output "LoadBalancerDNS" {
  value = aws_lb.NagiosLB.dns_name
}

output "NagiosClientPubIP" {
    value = aws_instance.Nagios_Client.*.public_ip
}
output "ALB_URL" {
    value = aws_lb.ALB_Terraform_VPC.dns_name
}



