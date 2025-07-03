#!/bin/bash

# Set constants
export NAME=yogi.k8s.local
export KOPS_STATE_STORE=s3://smart-file-analyzer-bucket
export AWS_REGION=ap-south-1

echo "✅ Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo install kubectl /usr/local/bin/
kubectl version --client

echo "✅ Installing AWS CLI..."
sudo apt update && sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

echo "⚠️ Make sure you’ve created an IAM user with correct permissions and configured using 'aws configure'"

echo "✅ Installing Kops..."
curl -Lo kops https://github.com/kubernetes/kops/releases/latest/download/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/
kops version

echo "✅ Creating Kubernetes cluster using Kops..."
kops create cluster --zones ${AWS_REGION}a ${NAME}
kops update cluster --name ${NAME} --yes --admin
