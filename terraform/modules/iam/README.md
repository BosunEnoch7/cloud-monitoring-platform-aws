# IAM Module

Owns IAM resources required by the EC2 monitoring host.

## Resources

- EC2 IAM role
- IAM instance profile
- AWS managed policy attachment for Systems Manager
- Project-scoped CloudWatch Logs write policy

## Why This Matters

The EC2 instance receives permissions through an IAM role instead of hardcoded
access keys. Systems Manager uses its AWS-managed core policy, while CloudWatch
log writes are restricted to this project's environment-specific log groups.
