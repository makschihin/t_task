# IAM policies config
resource "aws_iam_user_policy" "test_ssm_user" {
  name   = "test-ssm-user"
  user   = aws_iam_user.test_ssm_user.name

  policy = file("/home/maks/Learning/t_task/terraform/modules/iam/json_policies/test-ec2-admin.json")
}

resource "aws_iam_role_policy" "test_ec2_admin" {
  name   = "test-ec2-admin"
  role   = aws_iam_role.test_ec2_admin.id

  policy = file("/home/maks/Learning/t_task/terraform/modules/iam/json_policies/test-ec2-admin.json")
}
