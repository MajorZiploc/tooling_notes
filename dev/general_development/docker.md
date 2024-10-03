dcompose_file="docker-compose.yml"
docker compose -f "$dcompose_file" up -d
docker compose -f "$dcompose_file" down
docker exec -i -t "$container_name" dotnet run
docker exec -i -t "$container_name" bash

# list images
docker images / docker image ls

# list all images
docker images -a / docker image ls -a

# list running containers
docker ps / docker container ls

# list all containers
docker ps -a / docker container ls -a

# start a running container detached(-d) with name sleep_stonebraker from image running on local host port 6001 and docker container port 6379
docker run -d -p6001:6379 --name sleep_stonebraker <image_(?:name|id|image:tag)>

# start a running container
docker start <container_(?:name|id|image:tag)>

# restart a running container
docker restart <container_(?:name|id|image:tag)>

# stop a running container
docker stop <container_(?:name|id|image:tag)>

# remove / delete an image
docker rmi <image_(?:name|id|image:tag)>

# remove / delete a container
docker rm <container_(?:name|id|image:tag)>

# stop all running containers
docker ps -q

# get logs on the specified container
docker logs <container_(?:name|id|image:tag)> 
# to stream the logs from a container
docker logs <container_(?:name|id|image:tag)> -f

# run a bash session on a running container
docker exec -it <container_(?:name|id|image:tag)> /bin/bash

## A docker network is a way to organizate docker containers in a way where they can talk directly to each other through name instead of through ports

# show all networks
docker network ls

# create a new network
docker network create <network_name>

# If you have multiple bridge drivers, make sure that you starting your containers which will be talking with each other using same bridge network
docker run -d -t --network networkname  --name containername

# You will see details of network with list of containers. Each container will have IPv4Address associated with it. Use value of these address to communicate instead of localhost or 127.0.0.1
docker network inspect networkname

# create a container and connect it to a network
docker run -d -p27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --network mongo-network mongo

## Docker Compose

# start all containers and a network
docker-compose -f <file_name>.yaml up

# stop and tear down all containers and a network
docker-compose -f <file_name>.yaml down

## Docker Compose File

env_file prop can help remove redundant env var mappings in the compose file
    env_file:
      - docker-compose.env

## Dockerfile

# build a docker image with the given tag (image_name:image_version) using the Dockerfile in the current directory
docker build -t image_name:1.0 .

# Run a command in a docker container without staying in the container
docker exec -t <container name> <command must not be a string even if it has spaces>
# Example 1
docker exec -t devcontainer-pandas_data_analytics_app-1 python /workspace/src/fast_food/clean_scripts/el_pollo_loco.py
# Example 2
docker exec -i -t "$container_name" python manage.py test --pattern "test_application_activity_processor.py"

# find volume to ensure it is presisted between runs. most names will be hash unless you have a name in your docker compose
docker volume ls

# Prune things
docker container prune
docker image prune
docker network prune
docker volume prune
# Prune all the things
docker system prune

# Build images from docker compose
docker-compose -f compose.yml -f compose-prod.yml "service1 service2"

# glue: create 1 compose file out of multiple, it will inplace env vars
docker-compose -f compose.yml -f compose-dev.yml config > kompose.yml

# it'll clear out "everything"
docker-compose -f <compose_file.yml> down -v

# without the -v option and it'll clear out "everything" except the volumes
docker-compose -f <compose_file.yml> down --rmi all

# To refresh .env variables for an image, it is enough to do the following:

docker-compose -f compose.yml -f compose-prod.yml down -v
docker-compose -f compose.yml -f compose-prod.yml up --force-recreate

# stale database - may require clearing out volumes
docker volume rm $(docker volume ls -q)

# environment variables in docker compose
# DONT ASSUME THAT THE EXISTING ENVIRONMENT VARIABLES IN THE COMPOSE FILE ARE THE ONLY VALID ONES
# Example
# You want to switch to using the actual servers db instead of the local container db
# You will need to add the db user/pass/name into the backend server based on the backend settings file
# The env vars in the db container are useless once you switch the db host to the actual server url rather than the container name

# remote containers
https://code.visualstudio.com/remote/advancedcontainers/develop-remote-host
https://code.visualstudio.com/docs/remote/troubleshooting#_using-rsync-to-maintain-a-local-copy-of-your-source-code

## with remote source code

SSH_USER="user";
SSH_HOST="hostname";

### rsyncing back and forth remote and local
pull latest copy
function rsync_pull {
  rsync -rlptzv --progress --delete --exclude=.git "${SSH_USER}@${SSH_HOST}:/remote/source/code/path" .;
}
push local changes
function rsync_push {
  rsync -rlptzv --progress --delete --exclude=.git . "${SSH_USER}@${SSH_HOST}:/remote/source/code/path";
}

### sshfs like a volume into the remote machine

project_name='project1'

-- Make the directory where the remote filesystem will be mounted
mkdir -p "$HOME/projects-sshfs/${project_name}/w/${SSH_USER}@${SSH_HOST}";
-- Mount the remote filesystem
-- This will make your home folder on the remote machine available under the ~/projects-sshfs/${project_name}/w of your local machine.
sshfs "${SSH_USER}@${SSH_HOST}:" "$HOME/projects-sshfs/${project_name}/w/${SSH_USER}@${SSH_HOST}" -ovolname="${SSH_USER}@${SSH_HOST}" -p 22  \
    -o workaround=nonodelay -o transform_symlinks -o idmap=user  -C;
-- OPTIONAL if not tracking the .git in the sshfs session: track things locally temporarily
cd "$HOME/projects-sshfs/${project_name}/;
git init
git add .
git commit -m "init"

-- teardown
-- When you are done, you can unmount it using your OS's Finder / file explorer or by using the command line:
umount "$HOME/projects-sshfs/${project_name}/w/${SSH_USER}@${SSH_HOST}";
-- OPTIONAL if not tracking the .git in the sshfs session
rm -rf "$HOME/projects-sshfs/${project_name}/.git;

### sshing into the machine may be a good approach aswell
https://learn.umh.app/course/connecting-with-ssh/#:~:text=Open%20a%20terminal%20and%20enter,ssh%20rancher%40192.168.99.118%20.
ssh "${SSH_USER}@${SSH_HOST}";


#### pull in dotfiles
```bash
function _dotfiles {
  local og_dir=`pwd`;
  mkdir ~/projects;
  cd ~/projects:
  git clone https://github.com/MajorZiploc/dotfiles.git;
  cd dotfiles;
  ./setup/ubuntu/scripts/install_ssh.sh;
  ./shared/scripts/vim_shell/set_shells.sh;
  ./shared/scripts/zsh/install_oh-my-zsh.sh;
  ./setup/ubuntu/scripts/routine_update.sh;
  cd "$og_dir";
}
```
