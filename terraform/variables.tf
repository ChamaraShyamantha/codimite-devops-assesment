variable "project_id" {
  type    = string
  default = "codimite-assignment" 
}


variable "region" {
  type    = string
  default = "us-central1" 
}


variable "vpc_name" {
  type    = string
  default = "custom-vpc-codimite-assigment"
}

variable "subnet_cidr_ranges" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "gke_cluster_name" {
  type    = string
  default = "gke-cluster"
}

variable "general_pool_machine_type" {
  type    = string
  default = "e2-medium"
}

variable "cpu_intensive_machine_type" {
  type    = string
  default = "n2-highcpu-4"
}

variable "state_bucket_name" {
  type    = string
  default = "codemite-code-tf-bucket"
}
