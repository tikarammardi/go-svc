SHELL_PATH = /bin/ash

run:
	@echo "Running..."
	go run main.go
# Building containers

VERSION := 1.0.0

all: go-svc

service:
	docker build \
		-f zarf/docker/Dockerfile \
		-t go-svc-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.
