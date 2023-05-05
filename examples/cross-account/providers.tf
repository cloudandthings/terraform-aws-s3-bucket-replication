provider "aws" {
  region  = "af-south-1"
  profile = var.profile
}

provider "aws" {
  region  = "af-south-1"
  alias   = "account_A"
  profile = var.profile
}

provider "aws" {
  region = "af-south-1"
  alias  = "account_B"

  profile = var.profile

  assume_role {
    role_arn = "arn:aws:iam::000273210632:role/cat-genrl-prd-infra-github-workflows-xaccess"
  }
}
