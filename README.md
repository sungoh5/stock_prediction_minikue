# stock_prediction_minikue
This project provides an environment for running and developing stock-prediction service in a micro service environment through minikube.

## Environment
This project was tested in Ubuntu environment, but if minikube is installed, it will work the same in other environments.

* OS : Ubuntu 20.04

## Pre-condition
The following programs should be installed before you run this project

* [docker](https://docs.docker.com/engine/install/ubuntu/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [helm](https://helm.sh/docs/intro/install/)
* [minikube](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-minikube/)
* virtual box

## Initialize
This script set up the environment so that the local docker repository can be used, and deploys api-gateway and mongodb to minikube. 
```
$ ./init.sh
```
