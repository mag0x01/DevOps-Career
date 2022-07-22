# Let's test out the use of functions!
# You actually need to initialize the config before terraform console will work.
terraform init

terraform console

# Now we can try some different functions and syntax
min(42,5,16)
lower("DEVOPS")
join("_", ["school", "of", "devops"])

cidrsubnet("10.0.0.0/16", 8, 0)
cidrhost(cidrsubnet("10.0.0.0/16", 8, 0),5)
