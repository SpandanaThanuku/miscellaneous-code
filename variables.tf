variable "tools" {
  default = {

    sonarqube = {
      instance = "t3.large"
      port     = 9000
      priority = 100
      use_spot  = true
    }
    elasticsearch = {
      instance = "m6in.large"
      port     = 80
      priority = 101
      use_spot = true
    }
    prometheus = {
      instance = "t3.small"
      port     = 9090
      priority = 102
      use_spot = true
    }
    grafana = {
      instance = "t3.small"
      port     = 3000
      priority = 103
      use_spot = true
    }
    alertmanager = {
      instance = "t3.small"
      port     = 9093
      priority = 104
      use_spot = true
    }
    artifactory = {
     # instance = "r6i.xlarge"
      instance = "t3.medium"
      port     = 8082
      priority = 105
      use_spot = false  # means on demand instance
    }
  }
}