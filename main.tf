provider "aws" {
  region = "sa-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "ami" {
   source = "modules/ami"
}

module "ecs" {
  source = "github.com/katesclau/terraform-ecs"

  # Debug
  debug                = "${var.debug}"

  environment          = "${var.environment}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  key_name             = "${aws_key_pair.scadalts.key_name}"
  instance_type        = "${var.instance_type}"
  ecs_aws_ami          = "${module.ami.ecs_optimized_ami}"

  account              = "${var.account}"
  owner                = "${var.owner}"
}

module "task" {
   source = "modules/task"

   environment          = "${var.environment}"
   availability_zones   = "${var.availability_zones}"

   account              = "${var.account}"
   owner                = "${var.owner}"
}

module "service" {
   source = "modules/service"

   environment          = "${var.environment}"
   availability_zones   = "${var.availability_zones}"

   cluster_id           = "${module.ecs.ecs_cluster_id}"
   task_definition_arn  = "${module.task.task_definition_arn}"
   load_balancer_group_arn = "${module.ecs.default_alb_target_group}"

   account              = "${var.account}"
   owner                = "${var.owner}"
}

resource "aws_key_pair" "scadalts" {
  key_name = "scadalts"
  public_key = "${file("scadalts.pem.pub")}"
}

output "ecs_optimized_ami" {
    value = "${module.ami.ecs_optimized_ami}"
}

output "ecs_task_json" {
    value = "${module.task.ecs_task_json}"
}
