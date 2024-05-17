# Partition Disk Example

This repository demonstrates how to partition a disk on an Azure virtual machine using Terraform. By following the steps outlined in this README, you will be able to automate the process of provisioning an Azure virtual machine, attaching a managed disk, and partitioning the disk using Terraform.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- An Azure subscription
- Terraform installed on your local machine
- Azure CLI installed on your local machine
- Basic knowledge of Terraform and Azure

## Getting Started

To get started with partitioning a disk on an Azure virtual machine using Terraform, follow these steps:

1. **Clone this repository to your local machine:**
    ```bash
    git clone https://github.com/okaneconnor/Partition-Disk-Example.git
    ```

2. **Change into the cloned directory:**
    ```bash
    cd Partition-Disk-Example
    ```

3. **Initialize the Terraform working directory:**
    ```bash
    terraform init
    ```

4. **Review the Terraform configuration files to familiarize yourself with the resources being provisioned.**
    - Modify the `variables.tf` file to set your desired values for the virtual machine and managed disk configuration.

5. **Generate an SSH key pair for accessing the virtual machine:**
    ```bash
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
    Replace "your_email@example.com" with your email address or any other comment to identify the key.

6. **Apply the Terraform configuration:**
    ```bash
    terraform apply
    ```
    - Review the execution plan and confirm the changes by typing "yes" when prompted.
    - Once the Terraform configuration is applied successfully, you will see the public IP address of the virtual machine in the output.

7. **Connect to the virtual machine using SSH:**
    ```bash
    ssh -i <private_key_file> <username>@<public_ip_address>
    ```
    Replace `<private_key_file>` with the path to your private key file, `<username>` with the username for your VM, and `<public_ip_address>` with the public IP address of your virtual machine.
    - Once connected to the virtual machine, you can verify the disk partitioning by running the following commands:
      ```bash
      sudo fdisk -l /dev/sdc
      df -h /mnt/data
      ```

## Terraform Configuration

The Terraform configuration files in this repository define the necessary resources for provisioning an Azure virtual machine, attaching a managed disk, and partitioning the disk.

- `main.tf`: Contains the main Terraform configuration, including the resource definitions for the virtual machine, managed disk, and disk partitioning.
- `variables.tf`: Defines the input variables used in the Terraform configuration, such as the virtual machine size, disk size, and SSH key.
- `outputs.tf`: Specifies the output values that will be displayed after the Terraform configuration is applied, such as the public IP address of the virtual machine.

## Disk Partitioning Steps

The Terraform configuration includes a `null_resource` block that executes a set of commands on the virtual machine to partition and mount the attached disk. Here's an overview of the disk partitioning steps:

- Start the partitioning process using the `parted` utility.
- Create a GPT (GUID Partition Table) partition table on the disk.
- Create a primary partition spanning the entire disk and set the filesystem type to ext4.
- Exit the `parted` shell.
- Format the partition with the ext4 filesystem using `mkfs.ext4`.
- Create a mount point directory (`/mnt/data`).
- Mount the partition to the mount point using the `mount` command.
- Configure automatic mounting by adding an entry to the `/etc/fstab` file.

These steps are executed automatically on the virtual machine using the `remote-exec` provisioner in the Terraform configuration.

## Cleanup

To clean up the resources created by this Terraform configuration, run the following command:
```bash
terraform destroy
```

This command will destroy all the resources provisioned by Terraform, including the virtual machine, managed disk, and associated resources.

## Conclusion
By using this Terraform configuration, you can automate the process of partitioning a disk on an Azure virtual machine. The provided code and steps demonstrate how to provision the necessary infrastructure, connect to the virtual machine, and verify the disk partitioning.

Feel free to explore and modify the Terraform configuration files to suit your specific requirements and use case.

If you have any questions or feedback, please don't hesitate to reach out. Happy partitioning!
