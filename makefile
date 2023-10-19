SHELL_PATH = /bin/ash

run:
	@echo "Running..."
	go run main.go
# Building containers

VERSION := 1.0.3

all: service

service:
	docker build \
		-f zarf/docker/Dockerfile \
		-t go-svc-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

KIND_CLUSTER    := tikaram-dev-cluster
KIND            := kindest/node:v1.27.3
kind-up:
	kind create cluster \
		--image $(KIND) \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml
	kubectl config set-context --current --namespace=service-system

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-load:
	kind load docker-image go-svc-amd64:$(VERSION) --name $(KIND_CLUSTER)

kind-apply:
	kustomize build zarf/k8s/kind/service-pod | kubectl apply -f -

kind-update: all kind-load kind-restart

kind-update-apply: all kind-load kind-apply

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --all-namespaces

kind-logs:
	kubectl logs -f -l app=service --all-containers=true -f --tail=100

kind-restart:
	kubectl rollout restart deployment service-pod

kind-describe:
	kubectl describe pod -l app=service

tidy:
	go mod tidy
	go mod vendor