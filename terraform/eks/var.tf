variable "cluster_name" {

}
variable "subnet_ids" {
  type = list(string)
}
variable "instance_type" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "node_group_subnet_id" {}