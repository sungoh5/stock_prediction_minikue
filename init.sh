#!/bin/bash

function check_program_installed() {
  if ! command -v "$1" >/dev/null; then
      echo -e "Error: $1 is not installed, please check the pre-condition on README.md\n"
      exit 1
  fi
}

function run_minikube() {
minikube status > /dev/null
if [ $? -ne 0 ]; then
  echo -e "minikube is not running. run the minikube\n"
  minikube start
  return
fi
echo -e "minikube is already running.\n"
}

function use_common_namespace() {
  kubectl describe namespace common || kubectl create namespace common
  kubectl config set-context minikube --namespace=common
}

function deploy_mongodb() {
  # add bitnami repository on helm repo to deploy mongodb
  helm repo add bitnami https://charts.bitnami.com/bitnami

  helm upgrade --install --wait \
    --set auth.rootPassword=mongodb \
    --set persistence.mountPath=/tmp/mongodb \
    mongodb bitnami/mongodb
}

function deploy_api_gateway() {
  helm repo add kong https://charts.konghq.com

  git clone https://github.com/sungoh5/api-gateway.git  src/api-gateway

  helm upgrade --install --wait \
    --set ingressController.installCRDs=false \
    --set ingressController.enabled=false \
    --set proxy.type=NodePort \
    --set proxy.tls.enabled=false	 \
    --set proxy.http.nodePort=32000 \
    --values ./src/api-gateway/values.yaml \
    api-gateway kong/kong
}

function use_local_docker_repository() {
  echo -e "\n-----------------------------------------------------------"
  echo -e "Use local docker repository to deploy the image in minikube"
  echo -e "-----------------------------------------------------------\n"
  eval $(minikube docker-env)
}

for program in "helm" "kubectl" "minikube"; do
  check_program_installed "${program}"
done

run_minikube
use_common_namespace

deploy_mongodb
deploy_api_gateway

use_local_docker_repository
