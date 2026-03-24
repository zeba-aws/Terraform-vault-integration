provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://13.233.172.196:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "2a0c0d91-02d5-7500-764a-b9fe13aee628"
      secret_id = " 75d20a5b-7094-5adf-245e-24e7f47b23cb"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "kv" // change it according to your secret
}

resource "aws_instance" "terraform vault" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["test"]
  }
}
