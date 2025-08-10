# EKS Cluster Upgrade Plan: v1.32 to v1.33

Upgrading Amazon EKS clusters requires a methodical approach to ensure high availability, zero downtime for critical workloads, and full compatibility across the cluster stack. 
Below is the phased plan to upgrade from Kubernetes v1.32 to v1.33 in a secure and production-safe manner.

```bash

1. Backup All Critical Resources:
==================================
Before proceeding, ensure that all critical Kubernetes resources and application data are backed up.
Use tools like Velero or native snapshots for EBS volumes, and export manifests of custom resources, deployments, services, and config maps.

2. Review AWS EKS v1.33 Release Notes:
======================================
Carefully review the official AWS EKS v1.33 release notes to understand any deprecations, feature removals, and behavioral changes.
This ensures you are aware of potential impacts to workloads, APIs, or controller behaviors.

3. Perform Upgrade in Staging Environment First:
================================================
Always validate the upgrade process in a non-production or staging environment that closely mirrors production.
This allows you to identify compatibility issues and verify that workloads and add-ons function correctly post-upgrade.

4. Validate and Apply Pod Disruption Budgets (PDBs):
====================================================
Ensure Pod Disruption Budgets (PDBs) are properly configured for critical workloads to avoid unintentional service disruption during node replacements or rolling updates. 
This ensures graceful handling of voluntary disruptions.

5. Upgrade the Control Plane via AWS Console or CLI:
====================================================
Use the AWS Management Console, AWS CLI, or eksctl to upgrade the EKS control plane from v1.32 to v1.33. 
Monitor the progress and verify that the API server and control plane components stabilize successfully post-upgrade.

6. Launch New Worker Nodes Compatible with v1.33:
=================================================
Provision a new managed node group or self-managed nodes using Amazon EKS-optimized AMIs for Kubernetes v1.33. 
Ensure node IAM roles, security groups, and bootstrap configurations match existing standards.

7. Cordon and Drain Old Nodes:
==============================
Gradually cordon and drain the older v1.32 nodes to migrate workloads to the new v1.33 nodes.
This avoids downtime while enabling workload re-scheduling. After verification, the old node group can be safely deleted.

8. Upgrade EKS Add-ons and Custom Controllers:
==============================================
Update all EKS managed add-ons such as CoreDNS, kube-proxy, and VPC CNI to versions compatible with v1.33. 
Also, ensure any custom or third-party controllers (e.g., Ingress, CSI drivers) are updated and verified.

Final Validation & Monitoring:
===============================
Run post-upgrade smoke tests on workloads and cluster operations.
Monitor logs and metrics for anomalies using CloudWatch and Prometheus.
Review the upgrade impact and validate full functionality.

```
