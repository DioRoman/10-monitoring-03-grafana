# Создание сетей, подсетей и групп безопасности

module "yandex-vpc" {
  source       = "git::https://github.com/DioRoman/ter-final.git//src/modules/yandex-vpc?ref=main"
  env_name     = var.prometheus[0].env_name
  subnets = [
    { zone = var.vpc_default_zone[0], cidr = var.vpc_default_cidr[1] }
  ]
  security_groups = [
    {
      name        = "web"
      description = "Security group for web servers"
      ingress_rules = [
        {
          protocol    = "TCP"
          port        = 80
          description = "HTTP access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 443
          description = "HTTPS access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 22
          description = "SSH access"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 9090
          description = "Prometheus port"
          cidr_blocks = ["0.0.0.0/0"]
        },       
        {
          protocol    = "TCP"
          port        = 9100
          description = "Node-exporter port"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "TCP"
          port        = 3000
          description = "Grafana port"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ],
    egress_rules = [
        {
            protocol    = "ANY"
            description = "Allow all outbound traffic"
            cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
  ]
}

# Создание VM

module "prometheus" {
  source              = "git::https://github.com/DioRoman/ter-final.git//src/modules/yandex-vm?ref=main"
  vm_name             = var.prometheus[0].instance_name 
  vm_count            = var.prometheus[0].instance_count
  zone                = var.vpc_default_zone[0]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.prometheus[0].platform_id
  cores               = var.prometheus[0].cores
  memory              = var.prometheus[0].memory
  disk_size           = var.prometheus[0].disk_size 
  public_ip           = var.prometheus[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_ids["web"]]
  
  labels = {
    env  = var.prometheus[0].env_name
    role = var.prometheus[0].role
  }

  metadata = {
    user-data = data.template_file.prometheus.rendered
    serial-port-enable = local.serial-port-enable
  }  
}

module "node-exporter" {
  source              = "git::https://github.com/DioRoman/ter-final.git//src/modules/yandex-vm?ref=main"
  vm_name             = var.node-exporter[0].instance_name 
  vm_count            = var.node-exporter[0].instance_count
  zone                = var.vpc_default_zone[0]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.node-exporter[0].platform_id
  cores               = var.node-exporter[0].cores
  memory              = var.node-exporter[0].memory
  disk_size           = var.node-exporter[0].disk_size 
  public_ip           = var.node-exporter[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_ids["web"]]
  
  labels = {
    env  = var.node-exporter[0].env_name
    role = var.node-exporter[0].role
  }

  metadata = {
    user-data = data.template_file.node-exporter.rendered
    serial-port-enable = local.serial-port-enable
  } 
}

module "grafana" {
  source              = "git::https://github.com/DioRoman/ter-final.git//src/modules/yandex-vm?ref=main"
  vm_name             = var.grafana[0].instance_name 
  vm_count            = var.grafana[0].instance_count
  zone                = var.vpc_default_zone[0]
  subnet_ids          = module.yandex-vpc.subnet_ids
  image_id            = data.yandex_compute_image.ubuntu.id
  platform_id         = var.grafana[0].platform_id
  cores               = var.grafana[0].cores
  memory              = var.grafana[0].memory
  disk_size           = var.grafana[0].disk_size 
  public_ip           = var.grafana[0].public_ip
  security_group_ids  = [module.yandex-vpc.security_group_ids["web"]]
  
  labels = {
    env  = var.grafana[0].env_name
    role = var.grafana[0].role
  }

  metadata = {
    user-data = data.template_file.grafana.rendered
    serial-port-enable = local.serial-port-enable
  } 
}

# Инициализация 
data "template_file" "prometheus" {
  template = file("./prometheus.yml")
    vars = {
    ssh_public_key     = file(var.vm_ssh_root_key)
  }
}

data "template_file" "node-exporter" {
  template = file("./node-exporter.yml")
    vars = {
    ssh_public_key     = file(var.vm_ssh_root_key)
  }
}

data "template_file" "grafana" {
  template = file("./grafana.yml")
    vars = {
    ssh_public_key     = file(var.vm_ssh_root_key)
  }
}

# Получение id образа Ubuntu
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
