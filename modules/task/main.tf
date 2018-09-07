data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = [
        "sts:AssumeRole"
     ]

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name = "${var.environment}_task_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task.json}"
}

resource "aws_iam_policy" "task_policy" {
    name        = "${var.environment}_task_policy"
    description = "A Task control policy for ${var.environment} task role"
    policy = "${file("${path.module}/task_role_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "task_role_attach" {
  role       = "${aws_iam_role.task_role.name}"
  policy_arn = "${aws_iam_policy.task_policy.arn}"

  depends_on = ["aws_iam_role.task_role"]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.environment}_task"
  container_definitions = "${file("${path.module}/scadalts-task.json")}"
  task_role_arn = "${aws_iam_role.task_role.arn}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(",", var.availability_zones)}]"
  }
}


variable "availability_zones" {
  type = "list"
}

variable "account" {}
variable "owner" {}
variable "environment" {}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.task_definition.arn}"
}

output "task_role_arn" {
  value = "${aws_iam_role.task_role.arn}"
}

output "ecs_task_json" {
  value = "${data.aws_iam_policy_document.ecs_task.json}"
}
