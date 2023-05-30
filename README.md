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

The Istio deployment is defined in `k8s/istio-deployment.yml`. It includes traffic management through Istio, such that 90% of requests are routed to v1 of the frontend `app` and v2 are routed to v2. The different versions of the apps can be identified by different background colours. Prometheus is configued to collect app-specific metrics including `predictions_counter`, `wrong_predictions`, and `correct_predictions`. These two metrics are collected from both versions of the frontend `app`. 

The additional use case is the use of a shadow launch. Two versions of the model-service exist, and requests are mirrored to both. The use case of this functionality is that it is possible to compare the performance of the two model services without exposing the experimental one. We can compare how many times the models disagree in their sentiment assessment, as well as how long it took for both models to process the request.
