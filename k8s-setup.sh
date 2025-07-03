#!/bin/bash

set -e  # Exit if any command fails

# Set constants
export NAME=yogi.k8s.local
export KOPS_STATE_STORE=s3://smart-file-analyzer-bucket
export AWS_REGION=ap-south-1

# Save environment variables to .bashrc
echo "✅ Adding environment variables to ~/.bashrc..."
grep -qxF "export NAME=${NAME}" ~/.bashrc || echo "export NAME=${NAME}" >> ~/.bashrc
grep -qxF "export KOPS_STATE_STORE=${KOPS_STATE_STORE}" ~/.bashrc || echo "export KOPS_STATE_STORE=${KOPS_STATE_STORE}" >> ~/.bashrc
source ~/.bashrc

echo "✅ Installing kubectl..."
VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo install kubectl /usr/local/bin/
kubectl version --client

echo "✅ Installing AWS CLI..."
sudo apt update && sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version

echo "⚠️ Make sure you've configured AWS CLI using: aws configure"
echo "   (with correct IAM user credentials and region: ${AWS_REGION})"

echo "✅ Installing kops..."
curl -Lo kops https://github.com/kubernetes/kops/releases/latest/download/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/
kops version

echo "✅ Creating Kubernetes cluster using kops..."
kops create cluster --zones ${AWS_REGION}a ${NAME}
kops update cluster --name ${NAME} --yes --admin

echo "✅ All done! Use 'kops validate cluster' to check status."
