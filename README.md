# Operation

This repo uses docker to compose services from the following four repositories:

- [lib](https://github.com/remla23-team04/lib)
- [app](https://github.com/remla23-team04/app)
- [model-service](https://github.com/remla23-team04/model-service)
- [model-training](https://github.com/remla23-team04/model-training)

## Details about services

- lib defines a version aware library
- app is the frontend app that requests model predictions
- model-service allows to select an ML model and submit a review to apply the model to
- model-training contains data and trains the ML models

## Running the services

Below are guides for how to run the services through docker and through kubernetes

### Running the services through Docker

In order to run them:

- clone this repo
- `cd` into the repo root
- run `docker compose up`

The relevant images should be downloaded automatically.

The frontend app should then be available through `localhost:8080`

Alternatively you can build the images from scratch:

- clone this and the four repositories into the same directory
- `cd` into the operation repo root
- run `docker compose build` to build the services according to their `dockerfile`'s, or `docker compose up --build` to both build and run them

Run `docker compose down` to stop and remove the containers

### Running the services through Kubernetes

The Istio deployment is defined in `k8s/istio-deployment.yml`. It includes traffic management through Istio, such that 90% of requests are routed to v1 of the frontend `app` and v2 are routed to v2. The different versions of the apps can be identified by different background colours. Prometheus is configued to collect app-specific metrics including `predictions_counter`, `wrong_predictions`, and `correct_predictions`. These metrics are collected from both versions of the frontend `app`. More metrics are collected from the `model-service`.

To run everything start by installing istio and running `minikube start` you can then configure everything by executing the `istio-config.sh` script, and then apply the deployment using `istio-apply.sh`. This script also automatically removes previously applied deployments, so you can rerun it in order to apply changes. In order to verify that metrics are being collected you can check the `/metrics` endpoint. To do this for services that are not exposed you can port forward `kubectl port-forward deployment/model-service-deployment-v1 5001:5001`.

The additional use case is the use of a shadow launch. Two versions of the model-service exist, and requests are mirrored to both. The use case of this functionality is that it is possible to compare the performance of the two model services without exposing the experimental one. We can compare how many times the models disagree in their sentiment assessment, as well as how long it took for both models to process the request.


### Prometheus & Grafana
1. Start Docker. 
2. Run the following commands in the terminal of your choice, start minikube
```
minikube start
```
3. Download the required repos
```
helm repo add prom-repo https://prometheus-community.github.io/helm-charts
helm repo update
helm install myprom prom-repo/kube-prometheus-stack
```
4. Apply files to create pods
```
kubectl apply -f monitoring.yml
```
5. Check out what services you have using `kubectl get services`, should show something like this:
```
alertmanager-operated             ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   71s
myprom-alertmanager               ClusterIP   10.106.102.73   <none>        9093/TCP                     104s
myprom-grafana                    ClusterIP   10.106.24.159   <none>        80/TCP                       104s
myprom-kube-state-metrics         ClusterIP   10.106.89.92    <none>        8080/TCP                     104s
myprom-operator                   ClusterIP   10.103.76.34    <none>        443/TCP                      104s
myprom-prometheus                 ClusterIP   10.108.173.72   <none>        9090/TCP                     104s
myprom-prometheus-node-exporter   ClusterIP   10.106.27.31    <none>        9100/TCP                     104s
prometheus-operated               ClusterIP   None            <none>        9090/TCP                     70s
```
6. Run the services
```
minikube service my-service --url
minikube service myprom-prometheus --url
minikube service myprom-grafana --url
```

<details>
  <summary>Helper commands</summary>

```
minikube status
minikube service list
```

```
helm version
helm list
helm repo list
helm status myprom
helm uninstall myprom
```

```
kubectl get pods
kubectl delete pod --all
kubectl get services
```
  
</details>


<details>
  <summary>Troubleshooting</summary>

If somehow just running the commands above doesn't work 
(e.g. for me it stopped working at `helm install myprom prom-repo/kube-prometheus-stack`) 
you can create a new namespace, and instead of just running the commands in the `default` namespace
you can just add `--namespace <insert_namespace_name_here>` after every command from above. See below:
```
kubectl get services --namespace demo
```
  
</details>



Click the URL shown for Grafana and login using `user: admin, password: prom-operator`