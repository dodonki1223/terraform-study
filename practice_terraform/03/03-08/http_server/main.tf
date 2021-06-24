variable "instance_type" {}
variable "ec2_name" {}

resource "aws_instance" "default" {
    ami                    = "ami-0c3fd0f5d33134a76"
    // 「TYPE.NAME.ATTRIBUTE」の形式で掛けば他のリソースの値を参照することができる
    vpc_security_group_ids = [aws_security_group.default.id]
    instance_type          = var.instance_type

    // Apache のインストールだけだとセキュリティグループが許可されていないのでアクセスができない
    // vpc_security_group_ids に 80 番ポートを許可してアクセスできるようにする
    user_data = <<EOF
        #!/bin/bash
        yum install -y httpd
        systemctl start httpd.service
EOF

    tags = {
        Name = var.ec2_name
    }
}

/*
    セキュリティグループ
        セキュリティグループはインスタンスレベルで動作する。サブネットレベルで動作するのは「ネットワークACL」
        OSへ到達する前にネットワークレベルでパケットをフィルタリングできる

        デフォルトで許可されているのは同じセキュリティグループ内通信のみ（外からの通信は禁止）
        ステートフル（往路のみに適用される、復路は動的に開放される） - ホワイトリスト型（許可ルールを指定できる、拒否ルールは指定できない）
        ステートフルなので戻りのトラフィックを考慮しなくてよい
 */
resource "aws_security_group" "default" {
    name = "ec2"

    /*
        インバウンドルール
            受信トラフィックを制御
            デフォルトだとなにもないので追加しないとアクセスすることができない
     */
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    /*
        アウトバウンドルール
            送信トラフィックを制御
     */
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_dns" {
    value = aws_instance.default.public_dns
}
