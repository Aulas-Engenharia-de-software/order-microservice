variable "schedulers_config" {
  default = {
    start_schedule = {
      name          = "start_order_service"
      expression    = "cron(0 19 ? * MON,TUE,THU *)"
      desired_count = 1
    }
    stop_schedule = {
      name          = "stop_order_service"
      expression    = "cron(0 20 ? * MON,TUE,THU *)"
      desired_count = 0
    }
  }
}

variable "aws_account_id" {
  default = "624676054102"
}

variable "region" {
  default = "us-east-1"
}