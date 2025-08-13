variable "prometheus" {
  type = list(
     object({ env_name = string, instance_name = string, instance_count = number, public_ip = bool, platform_id = string,
     cores = number, memory = number, disk_size = number, role= string }))
  default = ([ 
    { 
    env_name          = "production",
    instance_name     = "prometheus", 
    instance_count    = 1, 
    public_ip         = true,
    platform_id       = "standard-v3",
    cores             = 2,
    memory            = 4,
    disk_size         = 10,
    role              = "prometheus"    
  }])
}

variable "node-exporter" {
  type = list(
     object({ env_name = string, instance_name = string, instance_count = number, public_ip = bool, platform_id = string,
     cores = number, memory = number, disk_size = number, role= string }))
  default = ([ 
    { 
    env_name          = "production",
    instance_name     = "node-exporter", 
    instance_count    = 1, 
    public_ip         = true,
    platform_id       = "standard-v3",
    cores             = 2,
    memory            = 2,
    disk_size         = 10,
    role              = "node-exporter"    
  }])
}

variable "grafana" {
  type = list(
     object({ env_name = string, instance_name = string, instance_count = number, public_ip = bool, platform_id = string,
     cores = number, memory = number, disk_size = number, role= string }))
  default = ([ 
    { 
    env_name          = "production",
    instance_name     = "grafana", 
    instance_count    = 1, 
    public_ip         = true,
    platform_id       = "standard-v3",
    cores             = 2,
    memory            = 4,
    disk_size         = 10,
    role              = "grafana"    
  }])
}