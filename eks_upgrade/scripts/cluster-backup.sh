#!/bin/bash
set -euo pipefail

echo "Script to backup cluster config in Kubernetes..."
echo "Script runs at: $(date '+%Y-%m-%d %H:%M:%S')"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="eks-backup-$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "Backing up all namespaces..."

# Backup all namespaced resources
for ns in $(kubectl get ns --no-headers -o custom-columns=":metadata.name"); do
  echo "Backing up namespace: $ns"
  mkdir -p "$BACKUP_DIR/namespaces/$ns"

  # Backup common resources in the namespace
  kubectl get all -n "$ns" -o yaml > "$BACKUP_DIR/namespaces/$ns/all-resources.yaml"
  kubectl get configmaps -n "$ns" -o yaml > "$BACKUP_DIR/namespaces/$ns/configmaps.yaml" || true
  kubectl get secrets -n "$ns" -o yaml > "$BACKUP_DIR/namespaces/$ns/secrets.yaml" || true
  kubectl get pvc -n "$ns" -o yaml > "$BACKUP_DIR/namespaces/$ns/pvc.yaml" || true
done

echo "Backing up cluster-wide resources..."

# Backup cluster-wide resources
mkdir -p "$BACKUP_DIR/cluster-wide"

kubectl get crds -o yaml > "$BACKUP_DIR/cluster-wide/crds.yaml"
kubectl get clusterroles -o yaml > "$BACKUP_DIR/cluster-wide/clusterroles.yaml"
kubectl get clusterrolebindings -o yaml > "$BACKUP_DIR/cluster-wide/clusterrolebindings.yaml"
kubectl get storageclasses -o yaml > "$BACKUP_DIR/cluster-wide/storageclasses.yaml"
kubectl get validatingwebhookconfigurations -o yaml > "$BACKUP_DIR/cluster-wide/validatingwebhooks.yaml"
kubectl get mutatingwebhookconfigurations -o yaml > "$BACKUP_DIR/cluster-wide/mutatingwebhooks.yaml"
echo "Backup completed at: $BACKUP_DIR"

# Prepare EBS volume info (snapshot must be created manually or via AWS CLI below)
echo "Collecting Persistent Volume info..."

kubectl get pv -o custom-columns="NAME:.metadata.name,VOLUME-ID:.spec.awsElasticBlockStore.volumeID" | tee "$BACKUP_DIR/pv-ebs-volume-ids.txt"

echo "==================================================================="
echo "To create AWS snapshots of EBS volumes manually, use AWSCLI commands"
echo "aws ec2 create-snapshot --volume-id <volume-id> --description \"EKS backup snapshot\""

exit 0
