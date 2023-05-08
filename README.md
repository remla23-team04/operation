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
