#for local testing/or local docker container
image=radio-proxy
container=radio-proxy
port=8002

if [ "$(docker ps -aq -f name=$container)" ]; then
  docker stop $container
  docker rm $container
fi

if [ "$(docker images -q $image)" ]; then
  docker image rm $image
fi

docker build -t $image -f Dockerfile . --build-arg PORT=$port
docker run --security-opt=no-new-privileges:false --network=host --restart=always --env PORT=8002 -v /home:/home -d -p $port:8010 --env-file=.env --name $container $image