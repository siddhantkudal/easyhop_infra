# easyhop_infra
easyhop infra creation

# 🚀 EasyShop Cloud Infrastructure on AWS

This Terraform project provisions the complete infrastructure required for the **EasyShop** application on AWS, including a custom VPC, networking components, and an Amazon EKS (Elastic Kubernetes Service) cluster.


**AWS REGION**
ap-south-1

**Terraform Version**
Terraform v1.11.3
on windows_amd64


## 📦 Modules Overview

- **VPC Module**
  - Custom VPC with public, private, and intra subnets across 2 AZs
  - Internet Gateway, NAT Gateway, Route Tables
  - EC2 Key Pair and Security Groups
- **EKS Module**
  - EKS control plane
  - Managed node group(s)
  - IAM roles and policies
  - Security groups for control plane and nodes
  - AWS Load Balancer Controller (IRSA setup)

- **VPC Module**
1. VPC Creation
A custom VPC is created with a CIDR block defined via the cidr_vpc variable.
The VPC is tagged for easy identification.

2. Subnets
Public Subnets: Two public subnets (ES_publicsubnet1 and ES_publicsubnet2) are created in different Availability Zones with public IP mapping enabled.
Private Subnets: Two private subnets for internal workloads like EKS worker nodes.
Intra Subnets: Additional intra-zone subnets for internal ELB or future use.

3. Internet Gateway & Route Tables
An Internet Gateway (my_igw) is attached to the VPC.
A route table is created for public subnets and associated accordingly.
A NAT Gateway is deployed in one public subnet to enable outbound internet access for private subnets.
Private route tables are created and associated with private subnets, routing traffic through the NAT Gateway.

- **EKS Module**

1. **EKS Control Plane**

- Uses the `terraform-aws-modules/eks/aws` module (v19.15.1)
- EKS cluster is deployed in **intra subnets**, making the control plane private (not publicly accessible)
- Cluster version and name are configurable via variables

2. **EKS Managed Node Group**

- Node group uses instance type passed via `var.instancetype`
- Supports auto-scaling with min, max, and desired count
- Nodes use a custom IAM role with EKS and EC2 policies
- Uses capacity type (e.g., ON_DEMAND or SPOT) via `var.typeInstance`

3. **IAM Configuration**
- IAM Role for EKS cluster with `AmazonEKSClusterPolicy` and `AmazonEKSServicePolicy`
- IAM Role for EKS nodes with:
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEC2ContainerRegistryReadOnly`
  - `AmazonEKS_CNI_Policy`
  - Custom ALB ingress controller policy (fetched from official GitHub and created dynamically)

4. **IRSA for ALB Ingress Controller**
- Configures IAM Role for Service Account (IRSA)
- OIDC provider created via `module.eks.oidc_provider_arn`
- ALB ingress controller gets necessary permissions via policy attachment

5. **Security Groups**
- Custom security group (`eks_cluster_sg`) for the EKS cluster
- Allows:
  - API server access on port 443
  - NodePort traffic on ports 80 and 30000–32767
  - Full outbound internet access

- **Authenticate and Run get-nodes.sh**

  Authenticate to AWS and Configure Kubeconfig
  Make sure your AWS CLI is configured

  CMD - aws configure

  Then update your local kubeconfig to connect with the EKS cluster

  aws eks --region {region-name} update-kubeconfig --name {cluster-name}

  update {} with details

  chmod +x get-nodes.sh

  Then execute the script
  
  ./get-nodes.sh

