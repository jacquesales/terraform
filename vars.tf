variable "amis" {
  type = map(string)
  default = {
    us-east-1-ubuntu-22 = "ami-080e1f13689e07408"
    us-east-1-ubuntu-20 = "ami-0cd59ecaf368e5ccf"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = {
    "t2" = "t2.micro"
  }
}

variable "read_capacity" {
  type        = number
  description = ""
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = ""
  default     = 5
}

variable "deletion_protection" {
  type        = bool
  description = ""
  default     = false
}

variable "vpc_config" {
  type = object({
    cidr_block = string
    subnets = list(object({
      name        = string
      public      = bool
      cidr_block  = string
      })
    )
  })
  default = {
    cidr_block = "10.0.0.0/16"
    subnets = [
      {
        name       = "private-a"
        public     = false
        cidr_block = "10.0.0.0/19"

      },
      {
        name       = "private-b"
        public     = false
        cidr_block = "10.0.32.0/19"
      },
      {
        name       = "private-c"
        public     = false
        cidr_block = "10.0.64.0/19"
      },
      {
        name       = "public-a"
        public     = true
        cidr_block = "10.0.128.0/19"
      },
      {
        name       = "public-b"
        public     = true
        cidr_block = "10.0.160.0/19"
      },
      {
        name       = "public-c"
        public     = true
        cidr_block = "10.0.192.0/19"
      }
    ]
  }
}
