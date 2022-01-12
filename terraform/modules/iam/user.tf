#IAM users configuration
resource "aws_iam_user" "test_ssm_user" {
  name          = "test-ssm-user"
  path          = "/"
  force_destroy = true
  
}

resource "aws_iam_access_key" "test" {
  user = aws_iam_user.test_ssm_user.name
}