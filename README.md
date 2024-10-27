For deploy new image:
sh build.sh
sudo docker tag radio-proxy mgerasika/radio-proxy:v1
sudo docker login
sudo docker push mgerasika/radio-proxy:v1

# on another pc
docker pull mgerasika/radio-proxy:v1
docker run --network=host --restart=always --env PORT=8002 -v /home:/home -d \
  -p $port:8002 \
  --name radio-proxy \
  mgerasika/radio-proxy:v1