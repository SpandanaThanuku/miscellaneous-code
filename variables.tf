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
    grafana = {
      instance = "t3.small"
      port     = 3000
      priority = 103
    }
    alertmanager = {
      instance = "t3.small"
      port     = 9093
      priority = 104
    }
    artifactory = {
      instance = "r6i.xlarge"
      port     = 8082
      priority = 105
    }
  }
}