provider "aws" {
    region  = "ap-northeast-1"
    profile = "terraform"
}

module "web_server" {
    // 対象のモジュールのソースがどこにあるか表す
    source        = "./http_server"
    // モジュールで使用する入力のパラメータになる
    // ※variable "instance_type" {} と宣言されている
    instance_type = "t3.micro"
}

// モジュールが出力するパラメータ
output "public_dns" {
    value = module.web_server.public_dns
}
