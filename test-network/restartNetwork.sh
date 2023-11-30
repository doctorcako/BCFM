docker stack rm bcfm_Core
sleep 2
docker stack rm bcfm_Cli
sleep 15

docker volume rm $(docker volume ls -q)

docker stack deploy -c /home/ubuntu/BCFM/test-network/docker/docker-compose-test-net.yaml -c /home/ubuntu/BCFM/test-network/docker/docker-compose-couch.yaml bcfm_Core
sleep 2

docker stack deploy -c  /home/ubuntu/BCFM/test-network/docker/docker-compose-cli.yaml bcfm_Cli