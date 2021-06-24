// AWSを使用するクレデンシャル情報をここで記述しておく
// なぜか profile を指定しても region の設定が効かなかったので追加しておく
provider "aws" {
    region  = "ap-northeast-1"
    profile = "terraform"
}

resource "aws_instance" "example" {
    ami           = "ami-0c3fd0f5d33134a76"
    instance_type = "t3.micro"

    // ユーザーデータを使用して Apache のインストールを行っている
    user_data = <<EOF
        #!/bin/bash
        yum install -y httpd
        systemctl start httpd.service
EOF
}
