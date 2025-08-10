#!/bin/bash
echo "Scrip to create/add new nodegroup to the existing cluster"
echo "Script runs at: $(date '+%Y-%m-%d %H:%M:%S')"

# --- VARIABLES ---
current_clustername="WorkWithAutomation"         # Change according to your setup
new_nodegroupname="green-nodes"                  # Change according to your setup
region="ap-south-1"                              # Change according to your setup
desired_capacity=2                               # Change according to your setup
k8s_version="1.33"                               # Change according to your setup

echo "Script begins now..."
echo "Creating new node group '$new_nodegroupname' for cluster '$current_clustername'..."

eksctl create nodegroup \
  --cluster "$current_clustername" \
  --name "$new_nodegroupname" \
  --node-type "t3.medium" \
  --nodes "$desired_capacity" \
  --nodes-min 2 \
  --nodes-max 4 \
  --region "$region" \
  --node-ami "auto" \
  --kubernetes-version "$k8s_version" \
  --managed

echo "Node group '$new_nodegroupname' successfully created and attached to cluster '$current_clustername'."
echo "===================================================================================================="
echo "Cross-checking whether the new nodes were added to the existing cluster..."
eksctl get nodegroup --cluster "$current_clustername"

exit 0

