default:
    @just --choose

setup: kind-create sealed-secrets-install argo-install

teardown: kind-delete

kind-create:
    kind create cluster --name learn-helm --config kind-config.yaml

kind-delete:
    kind delete cluster --name learn-helm

sealed-secrets-install:
    kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.4/controller.yaml

argo-install:
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl get pods -n argocd
    kubectl apply -f argo

argo-forward:
    kubectl port-forward svc/argocd-server -n argocd 8080:443

argo-password:
    kubectl -n argocd get secret argocd-initial-admin-secret \
        -o jsonpath="{.data.password}" | base64 -d; echo

datasette-forward:
   kubectl port-forward svc/datasette -n default 8001:80
