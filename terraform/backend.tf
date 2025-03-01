terraform {
  backend "gcs" {
    bucket = "ledgerndarytfstate"
    prefix = "terraformstate"
  }
}