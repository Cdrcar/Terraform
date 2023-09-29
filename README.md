# Terraform
## 1. Terraform ECR
We need to create 2 ECR repositories to store the Dockerfiles for the frontend and backend of the application.


To do this we can use IAC through Terraform to ensure that the infrastructure is the same each and every time it is set up.


The first thing we want to do is create a folder in the Terraform repo called Terraform ECR, then in this folder, create a main.tf file. At the top of this main.tf file you will need to put a provider tag with the AWS and the region us-east-1. You cannot use eu-west-2 because ECR is not available in all regions.


The next step is to google "AWS ECR Terraform module" or go to the [Terraform AWS ECR module documentation](https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest). Navigate down the page to the code for the Public Repository. For our purposes, we do not need any read write access rules, so we can take the first 5 lines of the code from source to repository_type and input into a main.tf file which you will have created.


```r
module "public_ecr" {
source = "terraform-aws-modules/ecr/aws"

repository_name = "public-example"
repository_type = "public"
}
```

You want to copy this twice, one for the frontend image and one for the backend image, changing the repository_name from public-example to frontend and backend.


From here you are ready to run the commands.


```
Terraform init

Terraform plan

Terraform apply
```


This should get the repository up and running in AWS.


## 2. Terraform EKS
The EKS cluster requires heavier architecture than the ECR, so it is necessary to use the module file format to organise the infrastructure as code. Create the file structure as follows:


### 2.1. File Structure


<pre>
Terraform EKS
|
|-- modules
| |
| |-- containerisation
| | |--main.tf
| | |-- output.tf
| | └── variables.tf
| |
| |-- networking
| | |--main.tf
| | |-- output.tf
| | └── variables.tf
| |
| |--RDS
| | |--main.tf
| | |-- output.tf
| | └── variables.tf
| |
| └── security-groups
| |--main.tf
| |-- output.tf
| └── variables.tf
|
|-- main.tf
|-- output.tf
└── variables.tf
</pre>


### 2.2. Containerisation EKS Module
We will want to copy the entire code from the [EKS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)  into the main.tf located in the containerisation repository.




There are a lot of inputs in the module. But the only ones we need to keep are:


<pre>
- source
- version
- cluster_name
- cluster_version
- vpc_id
- subnet_ids
- cluster_endpoint_public_access
- eks_managed_node_group_defaults
- ami_type = "AL@_x86_64"
- eks_managed_node_groups
- one = {
name
instance_types
max-size
desired_size
min_size
}
</pre>


For the attributes above, you will want to keep the variables the same as the example from the Terraform website.


The next step is to set up the other modules.


### 2.3. Networking Module
AWS EKS needs to run in a VPC. To create this, go to the [Terraform AWS VPC module documentation](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) and copy the code for the module into the networking main.tf folder.


You will need to keep all of the attributes and add tags for the public and private subnets using the following attribute


<pre>
public_subnet_tags
private_subnet_tags
</pre>


you will also want to get the data for the availability zones, and input them into the attribute azs.


### 2.4. RDS Module


Go to the [Terraform RDS resource documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance). Copy the code for basic usage into the rds main.tf file keeping the following attributes.


<pre>
- source
- version
- cluster_name
- cluster_version
- vpc_id
- subnet_ids
- cluster_endpoint_public_access
- eks_managed_node_group_defaults
- ami_type = "AL@_x86_64"
- eks_managed_node_groups
- one = {
name
instance_types
max-size
desired_size
min_size
}
</pre>


### 2.5. Modules
One of the key thing to remember when working with Terraform modules is that it is necessary to put any attribute (output) from any module or resource which will be needed as an argument (input) to another resource or module elsewhere in the code in the output.tf file of the same module folder so it can be referenced.


The outputs must be written in the following format:


```r
output "cluster_security_group_id" {
description = "Security group ids attached to the cluster control plane"
value = module.eks.cluster_security_group_id
}
```


``` r
output "username" {
description = "The master username for the database"
value = aws_db_instance.mydb.username
}
```


Note: For the value, you want to reference the name of the resource or module followed by the name of the attribute which can be found in the documentation on the Terraform website.


### 2.6. Security Group Module


The security group is a necessary input argument for the RDS database. This security group controls the ports which the database can access the VPC through. Go to the [AWS security group resource page](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) and add the following ingress code to allow postgress to access the database.


```r
ingress {
description = "postgress"
from_port = 5432
to_port = 5432
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
```


### 2.7. Root Directory
#### Providers
The providers file holds the information on what cloud provider Terraform is to be instructed to connect to. We are working with AWS, so we need to use the following code.


```r
terraform {

required_providers {
aws = {
source = "hashicorp/aws"
version = "5.0.1"
}
}

required_version = ">= 1.3.7"
}

provider "aws" {
region = var.region
}
```

#### Main
The root main.tf file is an important file as it connects all of the modules together. It allows the outputs from one module to be input into another module and referenced as a variable. Each of the modules need to be referenced in the following format.


```r
# Provision cluster
module "eks_cluster" {
source = "./modules/containerisation"

vpc_id = module.networking.vpc_id
private_subnets = module.networking.private_subnets
cluster_name = var.cluster_name
}
```


The first part is a name which you define. You then link the source folder of the module you want to use. Following this you place all of the input variables you need for the module to function.


You then need to follow this format with all of the modules in the module directory.


#### Outputs
The output.tf file in the root directory contains the attributes that will be output once the Terraform apply has been applied.


The most important output provisioning the application is the EKS cluster end-point as this will be used in the URL where the application is hosted on.


```r
output "cluster_endpoint" {
description = "Endpoint for EKS control plane"
value = module.eks_cluster.cluster_endpoint
}
```
### 2.8. Finishing off
The next steps are to make sure all of the variables and outputs are correctly connected together and referenced in the modules.


Once this is complete, type the following code into the console. This initialises the Terraform modules downloading all of the necessary data from the online repositories.


```
$ terraform init
```
The next console command is:


```
$ terraform plan
```
This shows you all of the infrastructure which will be implemented on AWS.


If you are happy with what is being built. The final step is to run


```
$ terraform apply
```
and type yes when asked to confirm.


It is likely you will have to do some trouble shooting, but the great thing about the Terraform platform is that it points you to where the errors are in the code, and makes it very clear what it is that you need to do to fix all of the errors.


Once you have worked through all of the errors in the code, and confirmed with a yes, the infrastructure will start to be created on the AWS cloud. Go to the web console to check that everything is as you desire.


When you want to remove the infrastructure run the command.


```
$ terraform destroy
