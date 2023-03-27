# Terraform module: SSM Parameter store path objects

A little utility module that simplifies fetching a collection of SSM parameters under a given path. This is useful for namespaces with larger number of parameters that are shared across multiple Terraform projects, typically a config.

## Example

Fetch and convert SSM parameters under `/config` path:

```
/config/s3/my-bucket/name = "my-bucket"
/config/foo/bar = "baz"
/config/example = "example"
```

Into a Terraform object:

```
{
  "/s3/my-bucket/name" = "my-bucket"
  "/foo/bar" = "baz"
  "/example" = "example"
}
```

### In code

```terraform
module "config" {
  source = "pavelpichrt/parameter-store-path-objects/aws"
  prefix = "/config"
}

# String params
resource "aws_s3_bucket" "my_bucket" {
  # Note that "/config" prefix doesn't need to be included
  bucket = module.config.string["/s3/my-bucket/name"]
}

# List params
resource "aws_s3_bucket" "availibility_zones" {
  # Note that "/config" prefix doesn't need to be included
  bucket = module.config.list["/vpc/availibility-zones"]
}
```
