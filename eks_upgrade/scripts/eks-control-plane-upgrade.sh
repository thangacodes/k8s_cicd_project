#!/bin/bash
echo "EKS control plane upgrade Script..."

# --- VARIABLES ---
CLUSTER_NAME="WorkWithAutomation"        # Change this to your actual cluster name
REGION="ap-south-1"                      # Change to your AWS region
TARGET_VERSION="1.33"

echo "Begin with EKS control plane upgrade..."
echo "Script run at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Cluster: $CLUSTER_NAME | Region: $REGION | Target Version: $TARGET_VERSION"

# --- USER CONFIRMATION ---
read -p "Are you sure you want to upgrade the control plane? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Upgrade cancelled."
  exit 1
fi

# --- UPGRADE CONTROL PLANE ---
echo "Initiating upgrade process..."
aws eks update-cluster-version \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --kubernetes-version "$TARGET_VERSION"

# --- WAIT AND MONITOR STATUS ---
echo "Waiting for upgrade to be complete. Checking every 30 seconds using while loop method..."

while true; do
  STATUS=$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" --query "cluster.status" --output text)
  VERSION=$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" --query "cluster.version" --output text)
  echo "Status: $STATUS | Current Version: $VERSION"
  if [[ "$STATUS" == "ACTIVE" && "$VERSION" == "$TARGET_VERSION" ]]; then
    echo "Upgrade to v$TARGET_VERSION completed successfully!"
    break
  fi
  sleep 30
done
exit 0
