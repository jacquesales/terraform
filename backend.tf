terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "projetosdevops"

    workspaces {
      name = "terraform"
    }
  }
}