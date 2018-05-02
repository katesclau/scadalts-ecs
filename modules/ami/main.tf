data "aws_ami" "ecs_ami" {
  most_recent      = true
  name_regex = "^amzn-ami-2017.09.l-amazon-ecs-optimized"
}

output "ecs_optimized_ami" {
  value = "${data.aws_ami.ecs_ami.image_id}"
}
