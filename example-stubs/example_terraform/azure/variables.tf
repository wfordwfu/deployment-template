variable "prefix" {
  description = "The Prefix used for all resources"
  default = "prod"
}

variable "region" {
  type    = string
  description = "The Azure region all resources should be created"
  default = "eastus"
}

variable "resource_group" {
  type    = string
  description = "The resource group all resources should be created"
  default = "rg-devops"
}

variable "storage_account" {
  type    = string
  default = "sa-devops"
}

variable "storage_container" {
  type    = string
  default = "sc-devops"
}