terraform {
  backend "remote" {
    organization = "dodonki1223-terraform"

    workspaces {
      name = "practice-terraform"
    }
  }
}

/*
  AWS の Credentials 情報をローカルで管理することができる
    workspace の設定で credential をローカルで持つようにすればOK（デフォルトはリモートになっているためエラーになる）
    以下のようなエラーになってしまう……
      ╷
      │ Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
      │
      │ Please see https://registry.terraform.io/providers/hashicorp/aws
      │ for more information about providing credentials.
      │
      │ Error: NoCredentialProviders: no valid providers in chain. Deprecated.
      │ 	For verbose messaging see aws.Config.CredentialsChainVerboseErrors
      │
      │
      │   with provider["registry.terraform.io/hashicorp/aws"],
      │   on provider.tf line 11, in provider "aws":
      │   11: provider "aws" {
      │
      ╵
    詳しくはこちらを：https://dev.classmethod.jp/articles/manage-tfstate-terraform-cloud/
 */
provider "aws" {
  region  = "ap-northeast-1"
  profile = "terraform"
}

