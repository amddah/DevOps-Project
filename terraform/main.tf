terraform{
    required_providers{
        aws = {
            source ="hachicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "s3"{
        key ="aws/ec2-deploy/terraform.ftstate"
        region = "eu-west-3"
    }
}

provider "aws" {
    region = var.region
}

resource "aws_instance" "name" {
    ami ="ami-07db896e164bc4476"
    instance_type ="t2.micro"
    key_name =aws_key_pair.deployer.key_name
    vpc_security_groups_id = [aws_security_group.maingroup.id]
    iam_instance_profile =aws_iam_instance_profile.ec2-profile.name
    connection{
        type = "ssh"
        host =self.public_api
        user="ubuntu"
        private_key =var.private_key
        timeout="4m"
    }

    tag ={
        "name" ="DeployVM"
    }
}

resource "aws_iam_instance_profile" "ec2-profile"{
    name ="ec2-profile"
    role = "EC2-ECR-AUTH"
    
}
resource "aws_security_group" "maingroup"{
    egress =[
        {
            cidr_blocks = ["0.0.0.0/0"]
            description = ""
            from_port =0
            ipv6_cidr_blockes =[]
            prefix_list_ids =[]
            protocol ="-i"
            security_groups =[]
            self =false
            to_port =0

        }
        
    ]
    ingress =[
         {
            cidr_blocks = ["0.0.0.0/0", ]
            description = ""
            from_port =22
            ipv6_cidr_blockes =[]
            prefix_list_ids =[]
            protocol ="tcp"
            security_groups =[]
            self =false
            to_port =22

        }, {
            cidr_blocks = ["0.0.0.0/0"]
            description = ""
            from_port =80
            ipv6_cidr_blockes =[]
            prefix_list_ids =[]
            protocol ="tcp"
            security_groups =[]
            self =false
            to_port =80

        }
    ]
}

resource "aws_key_pair" "deployer"{
    key_name = var.key_name
    public_key =var.public_key
}

output "instance_public_ip"{
    value =aws_instance.server.public_ip
    sensitive =true
}