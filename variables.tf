variable "tools" {
  default = {

    sonarqube = {
      instance = "t3.large"
      port     = 9000
      priority = 100
    }
    elasticsearch = {
      instance = "m6in.large"
      port     = 80
      priority = 101
    }
    prometheus = {
      instance = "t3.small"
      port     = 9090
      priority = 102
    }
  }
}