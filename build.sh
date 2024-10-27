#!/bin/bash

# Variables
image=radio-proxy
container=radio-proxy
port=8002

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$container)" ]; then
  docker stop $container
  docker rm $container
fi

# Remove the existing image if it exists
if [ "$(docker images -q $image)" ]; then
  docker image rm $image
fi

# Build the Docker image
docker build -t $image -f Dockerfile . --build-arg PORT=$port

# Run the Docker container
docker run --security-opt=no-new-privileges:false \
  --network=host \
  --restart=always \
  --env PORT=$port \
  -v /home:/home \
  --name $container \
  -d $image
