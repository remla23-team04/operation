# istioctl install
kubectl label ns default istio-injection=enabled
kubectl get ns default --show-labels
# Addons
kubectl apply -f ~/istio-1.17.2/samples/addons/prometheus.yaml
kubectl apply -f ~/istio-1.17.2/samples/addons/jaeger.yaml
kubectl apply -f ~/istio-1.17.2/samples/addons/kiali.yaml
istioctl analyze
kubectl get pods -n istio-system
