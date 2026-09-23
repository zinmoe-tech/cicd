# To delete all docker images
docker rm -f $(docker ps -aq)
docker image ls -aq | xargs -r docker image rm -f
docker image ls -aq | xargs -r docker image rm -f

# To build Dockerfile
docker build -t name:tag-vesion "destination" .

# To get docker image info such where images are stored
docker image inspect cicd-python-app:v1
docker info | grep "Docker Root Dir"
sudo ls -la /var/snap/docker/common/var-lib-docker

# Docker Run
docker run --rm cicd-python-app:v1

1. Creates a new container from the image cicd-python-app:v1
2. Runs it
3. When the program finishes, Docker deletes that container automatically