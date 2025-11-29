terraform {
	required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
		random = {
			source  = "hashicorp/random"
			version = "~> 3.7.2"
		}
    }

	backend "s3" {
	  bucket         = "terraform-state-agh-cloud-2026"
	  key            = "agh-cloud-project/terraform.tfstate"
	  region         = "us-east-1"
	  dynamodb_table = "terraform-lock"
	}
}