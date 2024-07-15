resource "aws_iam_role" "circleci_iam_role" {
  name = "circleci_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity",
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
      },
      Condition = {
        StringLike = {
          "${aws_iam_openid_connect_provider.circleci_oidc_provider.url}:sub" = "org/${local.secret_json.organisation_id}/*"
        }
      }
    }]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "circleci_iam_policy" {
  #checkov:skip=CKV_AWS_356:
  #checkov:skip=CKV_AWS_108: 
  #checkov:skip=CKV_AWS_109:
  #checkov:skip=CKV_AWS_110: 
  #checkov:skip=CKV_AWS_111
  statement {
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:SetDesiredCapacity",
      "backup:Start*",
      "codebuild:Start*",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds",
      "codepipeline:StartPipelineExecution",
      "dms:StartReplicationTask",
      "dms:StopReplicationTask",
      "dms:TestConnection",
      "dms:StartReplicationTaskAssessment",
      "dms:StartReplicationTaskAssessmentRun",
      "dms:DescribeEndpoints",
      "dms:DescribeEndpointSettings",
      "dms:RebootReplicationInstance",
      "dms:AddTagsToResource",
      "dms:CreateReplicationSubnetGroup",
      "dms:DeleteReplicationSubnetGroup",
      "dms:CreateReplicationInstance",
      "dms:DeleteReplicationInstance",
      "dms:CreateReplicationTask",
      "dms:DeleteReplicationTask",
      "dms:DescribeConnections",
      "dms:DescribeEndpoints",
      "dms:DescribeReplicationInstances",
      "dms:DescribeReplicationTasks",
      "dms:ModifyEndpoint",
      "dms:RemoveTagsFromResource",
      "dms:ModifyReplicationInstance",
      "dms:TestConnection",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "datasync:Create*",
      "datasync:Delete*",
      "datasync:Describe*",
      "datasync:List*",
      "datasync:TagResource",
      "datasync:StartTaskExecution",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "ecs:deregisterTaskDefinition",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:*Tasks",
      "ecs:ListServices",
      "ecs:CreateService",
      "ecs:*Task",
      "ecs:ListTaskDefinitions",
      "ecs:*TaskSet",
      "ecs:TagResource",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ec2:DescribeInstances",
      "ec2:RunInstances",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:AttachNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:Describe*",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "elasticfilesystem:Describe*",
      "elasticfilesystem:Create*",
      "elasticfilesystem:Delete*",
      "elasticfilesystem:restore",
      "glue:GetJobRuns",
      "glue:StartJobRun",
      "glue:GetJobs",
      "glue:GetJob",
      "glue:GetTable",
      "glue:BatchGetJobs",
      "glue:ListJobs",
      "glue:StartJobRun",
      "glue:StartTrigger",
      "glue:StopSession",
      "glue:StopTrigger",
      "glue:BatchStopJobRun",
      "glue:StopWorkflowRun",
      "glue:UpdateJob",
      "glue:TagResource",
      "glue:GetSecurityConfiguration",
      "glue:GetTags",
      "iam:CreatePolicyVersion",
      "iam:getRole",
      "iam:getRolePolicy",
      "iam:listAttachedRolePolicies",
      "iam:listInstanceProfilesForRole",
      "iam:listRolePolicies",
      "iam:ListRoles",
      "iam:PassRole",
      "iam:ListPolicyVersions",
      "iam:DetachRolePolicy",
      "kinesis:PutRecord",
      "kms:DescribeKey",
      "kms:Decrypt*",
      "kms:GenerateDataKey",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:DescribeResourcePolicies",
      "logs:Get*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:List*",
      "lambda:*",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:*Object*",
      "rds:*",
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DescribeSessions",
      "ssm:ResumeSession",
      "ssm:StartSession",
      "ssm:TerminateSession",
      "ec2:DescribeVpcs",
      "secretsmanager:GetSecretValue",
      "iam:GetPolicy",
      "dms:List*",
      "iam:GetPolicyVersion",
      "iam:DeletePolicyVersion",
      "dms:DescribeReplicationSubnetGroups",
      "dms:DescribeReplicationInstances",
      "dms:DescribeReplicationTasks",
      "dms:ModifyReplicationTask",
      "dms:DeleteReplicationTask",
      "dms:ModifyReplicationSubnetGroup",
      "logs:ListTagsLogGroup",
      "events:DescribeRule",
      "states:DescribeStateMachine",
      "events:ListTagsForResource",
      "states:ListStateMachineVersions",
      "events:ListTargetsByRule",
      "states:ListTagsForResource",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:DeleteRole",
      "iam:DeletePolicy",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "iam:GetPolicyVersion",
      "iam:AttachRolePolicy",
      "dms:CreateEndpoint",
      "dms:DeleteEndpoint",
      "states:StopExecution",
      "states:StartExecution",
      "states:Send*",
      "states:List*",
      "states:Get*",
      "states:Describe",
      "states:CreateActivity",
      "states:DeleteActivity",
      "states:CreateStateMachine",
      "states:DeleteStateMachine",
      "states:UpdateStateMachine",
      "events:PutRule",
      "events:EnableRule",
      "events:DeleteRule",
      "events:PutTargets",
      "events:PutEvents",
      "events:RemoveTargets",
      "events:Describe*",
      "events:List*",
      "events:EnableRule",
      "events:DisableRule",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:TerminateInstances",
      "ec2:RunInstances",
      "iam:AttachRolePolicy",
      "iam:DeleteRolePolicy",
      "states:TagResource",
      "states:UntagResource",
      "states:StartSyncExecution",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:TagLogGroup",
      "glue:CreateSecurityConfiguration",
      "glue:DeleteSecurityConfiguration",
      "glue:CreateUserDefinedFunction",
      "glue:DeleteUserDefinedFunction",
      "glue:CreateJob",
      "glue:CreateConnection",
      "glue:CreateRegistry",
      "glue:CreateSchema",
      "glue:CreateTable",
      "glue:GetTrigger",
      "glue:CreateTrigger",
      "glue:DeleteConnection",
      "glue:DeleteJob",
      "glue:DeleteRegistry",
      "glue:DeleteSchema",
      "glue:DeleteTable",
      "glue:DeleteTrigger",
      "glue:GetConnection",
      "iam:TagRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "circleci_iam_policy" {
  name        = "circleci_iam_policy"
  description = "Policy for CircleCI"
  policy      = data.aws_iam_policy_document.circleci_iam_policy.json
}


resource "aws_iam_policy_attachment" "circleci_policy_attachment" {
  policy_arn = aws_iam_policy.circleci_iam_policy.arn
  roles      = [aws_iam_role.circleci_iam_role.name]
  name       = "circleci_policy_attachment"
}
