packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
    amazon = {
      version = ">= 1.3.2"
      source = "github.com/hashicorp/amazon"
    }
  }
}
