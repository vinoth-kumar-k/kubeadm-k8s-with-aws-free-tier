# Kubeadm EC2 setup Terraform code

This repo is created to spin up - 1 control-plane EC2 and 2 data plane EC2s to be used to create a minimal 3 node kubeadm based k8s cluster in AWS utilising AWS free tier.

Repo code creates 3 t3.micro EC2 instances in ap-southeast-1 region in default vpc with public IPs.

If you are using this repo to spin up EC2s, please keep in mind not to run these EC2s for a combined time of more than 750 hours a month as that is the monthly free tier limit(inclusive of public IP usage).

Please enable free tier alerts in your aws accounts -  https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/tracking-free-tier-usage.html to be intimated if there is a cost overrun.

## Prerequisites

 - A free Tier AWS account
 - AWS Access Keys created in your account - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html # These are very sensitive and if leaked could lead to malicious actors hijacking your accounts, please use them wisely and deactivate/delete them from AWS if not needed after usage.
 - Create a new keypair called 'my-ec2-keypair' in AWS account to use to access EC2s via SSH - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
 - AWS CLI installed in your machine - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
 - Access keys configured in your machine for usage - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
 - Terraform installed in your machine - https://developer.hashicorp.com/terraform/install
 - Some Terraform Knowledge - https://developer.hashicorp.com/terraform/tutorials/aws-get-started
 - Your system public IP to supply during terraform plan/apply as input. e.g. 161.142.151.118/32

## Terraform Commands

To create the infrastructure needed in AWS, navigate to *'terraform/instances/my-instance'* directory and run below commands.

```bash
# To initialize Terraform modules and plugins locally run the below command

terraform init

# Plan terraform infrastructure and store it in a file

terraform plan --out='/tmp/tfplan'

# Apply the plan generated above

terraform apply /tmp/tfplan

#To remove the infrastructure after experimenting please run below command and delete all infra. Please don't create any infra outside of terraform as they won't be tracked here.

terraform apply -destroy

```
