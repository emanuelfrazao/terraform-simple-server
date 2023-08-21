variable "ami" {
  description = "The AMI to use for the server"
  default     = "ami-0eb260c4d5475b901" # Ubuntu 22.04
}

variable "instance_type" {
  description = "The type of instance to launch"
  default     = "t2.micro" # free tier
}