provider "aws" {
  region  = "af-south-1"
  alias   = "afs1"
  profile = var.profile
}

provider "aws" {
  region  = "eu-west-1"
  alias   = "euw1"
  profile = var.profile
}
