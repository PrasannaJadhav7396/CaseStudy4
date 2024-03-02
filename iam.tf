# Create an IAM policy to allow EC2 instances to access the S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.environment_id}-s3-access-policy"
  description = "Allows EC2 instances to access S3 bucket"
 
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:*"],
      Resource = [aws_s3_bucket.shared_bucket.arn, "${aws_s3_bucket.shared_bucket.arn}/*"]
    }]
  })
}
 
# Create an IAM role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name               = "${var.environment_id}-ec2-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}
 
# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
