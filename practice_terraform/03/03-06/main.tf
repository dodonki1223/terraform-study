provider "aws" {
    region  = "ap-northeast-1"
    profile = "terraform"
}

resource "aws_security_group" "example_ec2" {
    name = "example-ec2"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "example" { 
    ami                    = "ami-0c3fd0f5d33134a76"
    instance_type          = "t3.micro"
    // 「TYPE.NAME.ATTRIBUTE」の形式で掛けば他のリソースの値を参照することができる
    vpc_security_group_ids = [aws_security_group.example_ec2.id]

    // Apache のインストールだけだとセキュリティグループが許可されていないのでアクセスができない
    // vpc_security_group_ids に 80 番ポートを許可してアクセスできるようにする
    user_data = <<EOF
        #!/bin/bash
        yum install -y httpd
        systemctl start httpd.service
EOF
}

output "example_public_dns" {
    value = aws_instance.example.public_dns
}
