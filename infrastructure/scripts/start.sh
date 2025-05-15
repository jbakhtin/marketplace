#!/bin/bash

export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

set -e

echo "🚀 Starting Minikube..."
minikube start --driver=docker

echo "📦 Creating namespaces..."
kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -

echo "🧱 Applying infrastructure (logging stack)..."
kubectl apply -f ../logging/

echo "🧩 Applying microservices..."
kubectl apply -f ../services/marketplace-loms.yml

echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=180s -n logging
kubectl wait --for=condition=ready pod --all --timeout=180s

echo "🌐 Starting minikube tunnel in background..."
pkill -f "minikube tunnel" || true
(minikube tunnel > /dev/null 2>&1 &)

echo "🔍 Available services:"
minikube service list



echo "📊 OpenSearch Dashboards available via:"
minikube service dashboards -n logging --url

echo "✅ Everything should be up and running!"
