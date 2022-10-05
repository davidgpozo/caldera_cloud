#####################################
### Enviroment
#####################################

aws_region_name = "us-east-1"

aws_zones_names = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]

environment = "caldera-test"

#####################################
### Networking
#####################################

aws_vpc_cidr    = "172.23.0.0/16"
private_subnets = ["172.23.0.0/22", "172.23.32.0/22", "172.23.64.0/22", "172.23.96.0/22", "172.23.160.0/22"]
public_subnets  = ["172.23.4.0/22", "172.23.36.0/22", "172.23.68.0/22", "172.23.100.0/22", "172.23.164.0/22"]

#####################################
### RSA keys var for EKS
#####################################
rsa_key_path = "/tmp/"
rsa_key_name = "caldera-nodes"

#####################################
### Caldera server
#####################################
caldera_server_ami           = "ami-09d56f8956ab235b3"
caldera_server_instance_type = "t3.medium"

#####################################
### Linux host
#####################################
linux_host_ami           = "ami-09d56f8956ab235b3"
linux_host_instance_type = "t2.small"


#####################################
### Windows host
#####################################
windows_host_ami           = "ami-0f1ee03d06c4c659c"
windows_host_instance_type = "t3.medium"
