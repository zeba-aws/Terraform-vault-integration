provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address          = "http://13.126.166.229:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"
    
    parameters = {
      role_id   = "6b20e7f4-6147-cf43-92ad-080019019e91"
      secret_id = "90e568cf-45e1-7e8e-788e-d4f41d22c136"

    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "kv" // change it according to your secret
}

resource "aws_instance" "terraformvault" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"

  tags = {
    Name   = "test"
    Secret = data.vault_kv_secret_v2.example.data["test"]
  }
}
