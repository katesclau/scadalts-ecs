resource "aws_iam_role" "ecs_service" {
  name = "${var.environment}_ecs_service_role"
  assume_role_policy = "${file("${path.module}/ecs_role_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role       = "${aws_iam_role.ecs_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"

  depends_on = ["aws_iam_role.ecs_service"]
}

resource "aws_ecs_service" "service" {
  name            = "${var.environment}_service"
  cluster         = "${var.cluster_id}"
  task_definition = "${var.task_definition_arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service.arn}"

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${var.load_balancer_group_arn}"
    container_name   = "${var.environment}"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(",", var.availability_zones)}]"
  }
}

variable "environment" {}
variable "cluster_id" {}
variable "task_definition_arn" {}
variable "load_balancer_group_arn" {}
variable "availability_zones" {
  type = "list"
}

variable "account" {}
variable "owner" {}
