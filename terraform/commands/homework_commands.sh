# Let's run our homework
terraform init
terraform validate

# And we can store our sensitive data in environment variables like so
# For Linux and MacOS
export TF_VAR_aws_access_key=YOUR_ACCESS_KEY
export TF_VAR_aws_secret_key=YOUR_SECRET_KEY
export TF_VAR_public_key="YOUR_SSH_PUBLIC_KEY"

# For PowerShell
$env:TF_VAR_aws_access_key="YOUR_ACCESS_KEY"
$env:TF_VAR_aws_secret_key="YOUR_SECRET_KEY"
$env:TF_VAR_public_key="YOUR_SSH_PUBLIC_KEY"

# Now we can run plan without all that extra stuff
terraform plan -out homework.tfplan
terraform apply "homework.tfplan"

terraform show
terraform output

# You can always tear it down to save $$
terraform destroy
