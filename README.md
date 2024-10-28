# Terraform Infrastructure Setup

This Terraform configuration deploys a set of resources in Azure including

- a Virtual Network,
- Subnets,
- Key Vault,
- Application Gateway,
- Public IPs,
- Network Security Groups, and
- Virtual Machines with specific configurations.
  It also includes a random password generator stored in Azure Key Vault and a custom script to configure IIS servers on the VMs.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An Azure subscription.
- Azure CLI, logged in with `az login`, or an Azure service principal with sufficient permissions.
- export ARM_SUBSCRIPTION_ID=""
- Update resource group name is data.tf

## Configuration Overview

### Files

- **provider.tf**: Configures the Azure provider.
- **main.tf**: Sets up the main infrastructure components such as VMs, Key Vault, and network resources.
- **output.tf**: Defines outputs for VM names, public IPs, admin credentials, and access instructions.

### Resources Created

- Random Password: Generates a random password with special characters.
- Azure Key Vault: Stores the generated password for secure access.
- Virtual Network & Subnets:
  - Creates a primary subnet and an Application Gateway subnet.
- Application Gateway: Configured for path-based routing with separate backend pools for Images and Videos.
  - Path Routing: Routes /images/_ to the image backend pool and /videos/_ to the video backend pool.
- Network Security Group: Controls inbound traffic, allowing HTTP (80) and RDP (3389) access.
- Virtual Machines:
  - Two Windows VMs are configured with IIS.
  - Each VM hosts a unique web server directory (/Images for VM1 and /Videos for VM2).
- Custom Script Extension: Installs IIS on each VM and creates a specific Default.html file in the assigned folder.

## Usage

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo

   ```

2. Initialize Terraform:

````bash
terraform init

3. Modify Variables (if necessary):
Ensure you update subscription_id, client_id, client_secret, and tenant_id in provider.tf or configure these as environment variables.

4. Plan the Infrastructure:
```bash
terraform plan

5. Apply the Configuration:
```bash
terraform apply

Confirm with yes to create the resources.

6. Outputs: After a successful apply, Terraform will output:
VM names
Public IP addresses
Admin username
Access instructions for each VM
````
