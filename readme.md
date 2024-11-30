# Jitera Infrastructure Assignment

## Overview

This repository contains the Infrastructure as Code (IaC) solution for a Data Processing product. The architecture is designed to handle large-scale data processing workloads (up to 5TB per day), ensuring scalability, reliability, and quick response times, even during peak periods. The solution uses Terraform modules and Terragrunt to manage cloud resources efficiently. Additionally, Kafka Connect and Sink Connector have been integrated into the solution to facilitate seamless data flow, enabling backend service workers to process and store data efficiently.

### Problem Statement

The Data Processing product processes various types of data, including images, media files, 3D files, and PDFs. The infrastructure must handle:
- High data volume (5TB/day).
- Dynamic workload surges during peak times.
- Turnaround Time (TAT) commitments for users.
- Monitoring and quick reaction to performance issues.

## Architecture

The proposed architecture includes:
- **Amazon VPC**: Configured with private and public subnets for secure and efficient resource allocation.
- **NAT Gateway & Internet Gateway**: To enable internet access for private subnets while maintaining security.
- **Amazon S3 with Glacier**: For cost-effective data storage and archival.
- **Amazon EKS (Elastic Kubernetes Service)**: To manage containerized workloads and ensure scalability.
- **Amazon MSK (Managed Streaming for Apache Kafka)**: For reliable and high-throughput data streaming.
- **Amazon KMS (Key Management Service)**: For secure encryption of sensitive data.

### Kubernetes Additions

- **Kafka Connect**: Deployed on EKS to enable data integration and streaming pipelines.
- **Sink Connector**: Configured to process and transfer data to downstream systems, such as S3, once backend services are operational.

### Features

- **Scalable Infrastructure**: Automatically handles dynamic workload increases using Amazon EKS and MSK.
- **Cost Optimization**: Data is stored in Amazon S3 with Glacier for archival, reducing storage costs.
- **High Availability**: Leveraging private subnets, NAT Gateway, and a well-architected VPC design.
- **Monitoring**: Solution supports integration with AWS CloudWatch or third-party monitoring tools to detect performance issues and bottlenecks quickly.

## Technology Stack

- **IaC Tools**: 
  - [Terraform](https://www.terraform.io/): For infrastructure provisioning.
  - [Terragrunt](https://terragrunt.gruntwork.io/): To manage Terraform modules and ensure reusability.
- **Kubernetes**:
  - Kafka Connect and Sink Connector manifests.
- **AWS Services**:
  - Amazon VPC, NAT Gateway, Internet Gateway, S3, Glacier, MSK, KMS, and EKS.


## Deployment Instructions

1. **Pre-requisites**:
   - Terraform CLI installed.
   - Terragrunt CLI installed.
   - AWS CLI configured with appropriate IAM permissions.
   - kubectl installed and configured for the EKS cluster.

2. **Steps**:
   - Clone this repository:
     ```bash
     git clone https://github.com/exmachina30/jitera-infrastructure-assignment.git
     cd jitera-infrastructure-assignment
     ```
   - Navigate to the `terragrunt` directory.
   - Initialize and apply each module:
     ```bash
     terragrunt init
     terragrunt apply
     ```
   - Follow the prompts to confirm the changes.

3. **Kafka Connect Deployment**:
   - Navigate to the `k8s` directory.
   - Apply the manifests:
     ```bash
     kubectl apply -f ./k8s
     ```
   - Verify the deployment:
     ```bash
     kubectl get pods

## Future Enhancements

- Integration with monitoring tools (e.g., Prometheus and Grafana) for real-time insights.
- Autoscaling for MSK and EKS to handle extreme peak loads.
- Implement CI/CD pipelines for automated deployments.
- Development and integration of backend service workers for end-to-end data processing.

## Contributing

Feel free to fork this repository and submit pull requests for improvements. Ensure your code adheres to best practices and includes relevant documentation.

---

**Author**: [Hakim Rizki](mailto:hakimrizkip@gmail.com)
