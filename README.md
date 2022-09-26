# Schedule start/stop resource by tag

This project is to schuedle start/stop aws resource by specifial tag

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/Python-FFD43B?style=for-the-badge&logo=python&logoColor=blue)

## Installation

Follow the document to install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Deployment

1. Create the `terraform.tfvars` file
2. Copy the template and update the variable

```
aws_region = ""
aws_access_key_id = ""
aws_secret_access_key = ""
```

*For individual account can use aws cli `aws sts get-session-token --serial-number arn:aws:iam::<AccountID>:mfa/<Username> --token-code <MFA number>` to get the credential*

3. Deploy to AWS

```
terraform apply
```

## License
[MIT](https://github.com/reduxjs/react-redux/blob/HEAD/LICENSE.md)