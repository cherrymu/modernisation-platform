# AWS provider for the workspace you're working in (every resource will default to using this, unless otherwise specified)
provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids[terraform.workspace]}:role/ModernisationPlatformAccess"
  }
}

# AWS provider for the Modernisation Platform, to get things from there if required
provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"
}

# AWS provider for core-network-services to get the Transit Gateway attachment
provider "aws" {
  alias  = "core-network-services"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids["core-network-services-production"]}:role/ModernisationPlatformAccess"
  }
}

# AWS provider for core-vpc-production to retag VPC and subnets in the share account
provider "aws" {
  alias  = "core-vpc-production"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.environment_management.account_ids["core-vpc-production"]}:role/ModernisationPlatformAccess"
  }
}

provider "aws" {
  alias  = "bucket-replication"
  region = "eu-west-1"
}
