# Terraform module: SSM Parameter store path objects

A little utility module that simplifies fetching a collection of SSM parameters under a given path. This is useful for namespaces with larger number of parameters that are shared across multiple Terraform projects, typically a config.

## Usage

Given the following parameters in SSM:

```
/config/s3/my-bucket/name = "my-bucket"
/config/foo/bar = "baz"
```

```terraform
module "config" {
  source = "pavelpichrt/parameter-store-path-objects/aws"
  prefix = "/config"
}

resource "aws_s3_bucket" "my_bucket" {
  # Note that "/config" prefix doesn't need to be included
  bucket = module.config._["/s3/my-bucket/name"]
}
```
