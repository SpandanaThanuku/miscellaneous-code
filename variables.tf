variable "tools" {
  default = {

    sonarqube = {
      instance = "t3.large"
      port     = 9000
      priority = 100
    }

  }
}
