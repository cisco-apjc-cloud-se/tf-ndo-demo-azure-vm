variable "tenant" {
  type = string
}

### AZURE APPS ###
variable "public_key" {
  type = string
}

variable "public_key_rsa" {
  type = string
}

variable "azure_apps" {
  type = map(object({
    name = string
    segment = string
    regions = map(object({
        name = string
        vpc_cidr = string
        instances = map(object({
            tier = string # EPG
            subnet_cidr = string
            instance_name = string
            instance_count = number
        }))
    }))
  }))
}
