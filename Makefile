# Export docker-machine variablees
ENVIRONMENT=rust-graphql
TLS_VERIFY=$(shell docker-machine env $(ENVIRONMENT) | grep 'DOCKER_TLS_VERIFY=".*"' | cut -d\" -f2)
HOST=$(shell docker-machine env $(ENVIRONMENT) | grep 'DOCKER_HOST=".*"' | cut -d\" -f2)
CERT_PATH=$(shell docker-machine env $(ENVIRONMENT) | grep 'DOCKER_CERT_PATH=".*"' | cut -d\" -f2)
MACHINE_NAME=$(shell docker-machine env $(ENVIRONMENT) | grep 'DOCKER_MACHINE_NAME=".*"' | cut -d\" -f2)
export DOCKER_MACHINE_NAME=$(MACHINE_NAME)
export DOCKER_TLS_VERIFY=$(TLS_VERIFY)
export DOCKER_HOST=$(HOST)
export DOCKER_CERT_PATH=$(CERT_PATH)
export DOCKER_IP=$(shell docker-machineip $(ENVIRONMENT))

default:
	docker ps

docker-machine-create:
	docker-machine --driver virtualbox $(ENVIRONMENT)

docker-machine-start:
	docker-machine start $(ENVIRONMENT)

build: build-docker

build-rust:
	docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder cargo build --release --target x86_64-unknown-linux-musl

build-docker: build-rust
	docker build -t rust-graphql .

run:
	docker run --rm --name rust-graphql -p 8080:8080 rust-graphql;

browser:
	open "http://${DOCKER_IP}:8080/"

.PHONY: build build-docker build-rust browser run init-docker