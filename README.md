## Developing with Docker

Reference project: https://gitlab.com/twn-devops-bootcamp/latest/07-docker/js-app  

This demo app shows a simple user profile app set up using 
- index.html with pure js and css styles
- nodejs backend with express module
- mongodb for data storage

For instructions to run, please checkout specific branches.

### On branch *docker-compose*

Application is ran locally, MongoDB and Mongo Express are ran via a docker compose file.

Step 1: 

    docker-compose -f mongo.yaml up

Follow Step *4 - 6* below to start application locally.
### On branch *local-development*

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
