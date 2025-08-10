#!/bin/bash
echo "Script to upgrade EKS workernode group..."
echo "Script run at: $(date '+%Y-%m-%d %H:%M:%S')"

# --- VARIABLES ---
old_nodegroup_name="blue-nodes"
new_nodegroup_name="green-nodes"
DRY_RUN=false  # Set to true for testing (no actual drain)

echo "Starting cordon and drain of nodes from current nodegroup: $old_nodegroup_name"
echo "New nodegroup: $new_nodegroup_name"

# --- FETCH CURRENT NODEGROUP NODES ---
NODE_LABEL="eks.amazonaws.com/nodegroup=${old_nodegroup_name}"
NODES=$(kubectl get nodes -l "$NODE_LABEL" -o name)

if [ -z "$NODES" ]; then
  echo "No nodes found with label: $NODE_LABEL"
  exit 1
fi

# --- CORDON & DRAIN EACH NODE ---
for NODE in $NODES; do
  NODE_NAME=${NODE##*/}
  echo "Processing node: $NODE_NAME"
  echo "Cordoning node..."
  kubectl cordon "$NODE_NAME"
  if [ "$DRY_RUN" = false ]; then
    echo "Draining node..."
    kubectl drain "$NODE_NAME" --ignore-daemonsets --delete-emptydir-data --force
  else
    echo "[Dry Run] would drain node: $NODE_NAME"
  fi
done
echo "All nodes from '$old_nodegroup_name' have been cordoned and drained."

exit 0
