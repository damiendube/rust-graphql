#!/usr/bin/env bash -X

rustup target install x86_64-unknown-linux-musl

# Export docker-machine variablees
DOCKER_ENVIRONMENT=rust-graphql

docker-machine create --driver virtualbox ${DOCKER_ENVIRONMENT}
docker-machine start ${DOCKER_ENVIRONMENT}

eval $(docker-machine env ${DOCKER_ENVIRONMENT})
DOCKER_IP=$(docker-machine ip ${DOCKER_ENVIRONMENT})

echo "Build rust project"
docker run -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder cargo build --release --target x86_64-unknown-linux-musl

echo "Build Docker container"
docker build -t rust-graphql .


