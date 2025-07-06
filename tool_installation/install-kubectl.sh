#!/bin/bash
echo "Script runs at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Checking if kubectl is already installed..."
# Check if kubectl exists
if command -v kubectl &> /dev/null; then
  echo -e "\n kubectl is already installed at: $(which kubectl) \n"
  echo -e "\n Installed version: \n"
  kubectl version --client
else
  echo "kubectl not found. Installing..."
    # Get the latest stable version
    KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    echo -e "\n Downloading kubectl from: $KUBECTL_URL \n"
    # Download kubectl
    curl -LO "$KUBECTL_URL"
    # Make it executable and move to /usr/local/bin
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/kubectl
    # Verify installation
    echo -e "\n kubectl installed successfully..\n"
    kubectl version --client
fi
exit 0
