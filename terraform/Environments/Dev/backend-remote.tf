terraform {
  backend "s3" {
    bucket = "infra-foundation-tfstate-723591018998"

    key    = "iot-platform/dev/network/terraform.tfstate"

    region = "ap-south-1"

    encrypt = true

    use_lockfile = true
  }
}

