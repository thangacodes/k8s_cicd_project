#!/bin/bash
echo "Script runs at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Checking if eksctl is already installed..."
if command -v eksctl &> /dev/null; then
  echo -e "\n eksctl is already installed at: $(which eksctl)"
  echo -e "\n Installed version:"
  eksctl version --client
else
  echo -e "\n eksctl not found. Installing..."
  # Download and extract the latest version
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  # Move it to /usr/local/bin
  sudo mv /tmp/eksctl /usr/local/bin
  # Verify installation
  echo -e "\n eksctl installed successfully."
  eksctl version --client
fi
exit 0
