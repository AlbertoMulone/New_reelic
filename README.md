# legalcert.newrelic

## requirements
- terraform 1.4.6
- terragrunt 0.45.18
- newrelic 3.25.2

## setup

### login aws sso on your pc/mac
```bash
aws sso login --profile=<any profile name>
```

### on dev container
how to get you API keys
https://docs.newrelic.com/docs/apis/get-started/intro-apis/types-new-relic-api-keys

export enviroment variables:
```bash
export AWS_PROFILE=<aws profile lcert-pr>
export NEW_RELIC_ACCOUNT_ID=<account_id>
export NEW_RELIC_API_KEY= NRAK-<newrelic_api_key>
```

download requirements providers and check installation:
```
cd live/test/<module>
terragrunt init
```

### common errors
```
Error finding AWS credentials (did you set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables?): SSOProviderInvalidToken: the SSO session has expired or is invalid
```
login again with aws sso on your pc/mac
```
Remote state S3 bucket lcert-pr-aws-newrelic-state does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n)
```
wrong AWS_PROFILE, export correct profile to lcert-pr account

### update to S3 backend
```
cd live/test
terragrunt run-all init -reconfigure
cd live/stage
terragrunt run-all init -reconfigure
cd live/prod
terragrunt run-all init -reconfigure
cd live/global
terragrunt run-all init -reconfigure
```

### update newrelic provider
```
cd live/test
terragrunt run-all init -upgrade
cd live/stage
terragrunt run-all init -upgrade
cd live/prod
terragrunt run-all init -upgrade
cd live/global
terragrunt run-all init -upgrade
```

## commands

### format
before commit format all file inside root project directory:
```
terragrunt hclfmt -recursive
terraform fmt -recursive
```

### plan
print what will change without changing it:
```
cd live/test/<module>
terragrunt plan
```

### apply
apply your plan (need confirm 'yes'):
```
cd live/test/<module>
terragrunt apply
```

## links
- https://www.terraform.io/docs/providers/newrelic/
- https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca
  - https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c
  - https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180
  - https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
  - https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d
  - https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
  - https://blog.gruntwork.io/how-to-use-terraform-as-a-team-251bc1104973
- https://github.com/antonbabenko/terraform-best-practices/tree/master/examples/medium-terraform
