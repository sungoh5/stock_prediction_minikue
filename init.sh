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
  helm upgrade --install --wait \
    --set auth.rootPassword=mongodb \
    --set persistence.mountPath=/tmp/mongodb \
    mongodb bitnami/mongodb
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

# add bitnami repository on helm repo to deploy mongodb
helm repo add bitnami https://charts.bitnami.com/bitnami

deploy_mongodb
use_local_docker_repository
