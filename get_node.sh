#!/bin/bash

# Description: List all EKS cluster nodes using kubectl

echo "Fetching all EKS cluster nodes..."

# Ensure kubeconfig is set properly
if ! kubectl config current-context &>/dev/null; then
    echo "Kubeconfig not set or kubectl not configured. Exiting."
    exit 1
fi

# List all nodes with some basic details
kubectl get nodes -o wide
