default:
    @just --choose

start-kind:
    kind create cluster --name learn-helm --config kind-config.yaml

install-argo:
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl get pods -n argocd
