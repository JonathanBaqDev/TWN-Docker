# Developing with Docker

Reference project: https://gitlab.com/twn-devops-bootcamp/latest/07-docker/js-app  

This demo app shows a simple user profile app set up using 
- index.html with pure js and css styles
- nodejs backend with express module
- mongodb for data storage

For instructions to run, please checkout specific branches.

## On branch *nexus-deploy*

App, MongoDB and Mongo Express are all ran via `docker compose`. App image is pulled from a private nexus repository.

Check branch *nexus-publish* and [TWN-Nexus-Gradle](https://github.com/JonathanBaqDev/TWN-Nexus-Gradle) to setup Nexus and publish the app image.

Step 1: Fill in the docker-compose file with the Nexus host IP, docker repo port and name. Un-comment the lines afterwards by removing the #.

Step 2: On the deployment server

- Authenticate to the Nexus repo via `docker login <Nexus_server_IP>:<docker_repo_port>`
- Copy docker-compose file to server - you can also create a new file and copy the contents via `vim`
- Start containers with `docker-compose -f docker-compose.yaml up`

## On branch *nexus-publish*

*These are steps to publish the app image to a Nexus repository, check *docker-image* branch's instructions on how to run the app*

#### Create Docker Repository

Check: [TWN-Nexus-Gradle](https://github.com/JonathanBaqDev/TWN-Nexus-Gradle) for steps to configure Nexus on a server

In Nexus:

1. Go to **Repositories** → **Create repository**.
2. Select **Docker (hosted)** and create.
3. Configure a **Repository Connector**:
   - HTTP port: `<docker_repo_port>`
4. Save the repository.

#### Configure Repository Access

Create a dedicated role with permissions to access the Docker repository.

1. Go to **Security** → **Roles**.
2. Create a new role.
3. Assign the required Docker repository privileges.
4. Assign the role to the relevant user.

#### Enable Docker Bearer Token Realm:

**Security → Realms** - Activate Docker bearer token realm

#### On server firewall - Allow inbound traffic to the Docker repository connector port.

#### Configure Docker

Since the current Nexus deployment uses HTTP, configure Docker to allow the Nexus registry as an insecure registry.

On Docker Desktop go to:

**Settings → Docker Engine**

Add the Nexus registry to `insecure-registries`:

```json
{
  "insecure-registries": [
    "<Nexus_server_IP>:<docker_repo_port>"
  ]
}
```

#### Authenticate
    docker login <Nexus_server_IP>:<docker_repo_port>

#### Tag image

*Check instructions on how to build the app image in branch **docker-image***

    docker tag my-app:1.0 <Nexus_server_IP>:<docker_repo_port>/my-app:1.0

#### Push image
    docker push <Nexus_server_IP>:<docker_repo_port>/my-app:1.0

#### Query Nexus API
    curl -u <username>:<password> -X GET "http://<Nexus_server_IP>:8081/service/rest/v1/components?repository=<docker_repo>"

## On branch *docker-image*

Application is ran in Docker, MongoDB and Mongo Express are ran via `docker compose`.

Step 1: Create application image, run this command where the Dockerfile is located:

    docker build -t my-app:1.0 .

Step 2: Run MongoDB and Mongo Express from docker compose

    docker-compose -f docker-compose.yaml up

Step 3: Run your application container, check which network the Mongo containers are in and specify your local ports:

    docker network ls
    docker run --network <network-name> -p 3000:3000 my-app:1.0

Follow Steps 4 & 5 in branch *local-development* to setup the DB, access the application from `http://localhost:3000`

## On branch *docker-compose*

Application is ran locally, MongoDB and Mongo Express are ran via `docker compose`.

Step 1: 

    docker-compose -f docker-compose.yaml up

Follow Step *4 - 6* below to start application locally.
## On branch *local-development*

Application is ran locally, MongoDB and Mongo Express are ran in Docker

#### To start the application

Step 1: Create docker network

    docker network create mongo-network 

Step 2: start mongodb 

    docker run -d \
    -p 27017:27017 \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=password \
    --net mongo-network \
    --name mongodb \
    mongo    

Step 3: start mongo-express
    
    docker run -d \
    -p 8081:8081 \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
    -e ME_CONFIG_BASICAUTH_USERNAME=user \
    -e ME_CONFIG_BASICAUTH_PASSWORD=pass \
    -e ME_CONFIG_MONGODB_SERVER=mongodb \
    -e ME_CONFIG_MONGODB_URL=mongodb://mongodb:27017 \
    --net mongo-network \
    --name mongo-express \
    mongo-express   

_NOTE: creating docker-network is optional. You can start both containers in a default network. In this case, just omit `--net` flag in `docker run` command_

Step 4: open mongo-express from browser

    http://localhost:8081

Step 5: create `user-account` _db_ and `users` _collection_ in mongo-express

Step 6: Start your nodejs application locally - go to `app` directory of project 

    cd app
    npm install 
    node server.js
    
Step 7: Access you nodejs application UI from browser

    http://localhost:3000
