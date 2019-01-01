#!/usr/bin/env bash -X

rustup target install x86_64-unknown-linux-musl

# Export docker-machine variablees
DOCKER_ENVIRONMENT=rust-graphql

docker-machine create --driver virtualbox ${DOCKER_ENVIRONMENT}
docker-machine start ${DOCKER_ENVIRONMENT}

eval $(docker-machine env ${DOCKER_ENVIRONMENT})
DOCKER_IP=$(docker-machine ip ${DOCKER_ENVIRONMENT})

docker rm --force rust-graphql
docker run -d --rm --name rust-graphql -p 8080:8080 rust-graphql
open "http://${DOCKER_IP}:8080/graphiql"

exit 0;