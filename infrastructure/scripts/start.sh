#!/bin/bash
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
# Убедиться, что Minikube работает
minikube start

# Применить логирование
kubectl apply -f ../logging/

# Применить микросервисы
kubectl apply -f ../services/

# Открыть OpenSearch Dashboards в браузере
#minikube service dashboards -n logging
