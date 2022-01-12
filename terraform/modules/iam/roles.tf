# IAM Policy with assume role to EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions       = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role config
resource "aws_iam_role" "test_ec2_admin" {
  name                     = "test-ec2-admin"
  path                     = "/"
  assume_role_policy       = data.aws_iam_policy_document.ec2_assume_role.json
}

# IAM instance profile
resource "aws_iam_instance_profile" "test_ec2_admin" {
  name = "test-ec2-admin"
  role = aws_iam_role.test_ec2_admin.name
}