# Terraform Network Template

Reusable AWS network template for future projects.

It creates:

- VPC
- Public subnets
- Private subnets
- Internet gateway
- Public route table
- Private route table
- Optional NAT gateway
- Public security group
- Private security group

## Usage

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` for the project, then run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

For lower-cost development environments, keep:

```hcl
single_nat_gateway = true
```

For production-style high availability, use one NAT gateway per public subnet:

```hcl
single_nat_gateway = false
```

To disable NAT gateways completely:

```hcl
enable_nat_gateway = false
```

