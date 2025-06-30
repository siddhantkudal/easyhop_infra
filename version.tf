terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66"  # ✅ Stable
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.10"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
