# Ping Pong API

## Endpoints
- /ping - Responds with {'pong'}
- /pong - Responds with {'ping'}
- /professional-ping-pong - Responds with {'pong'} 90% of the time
- /amateur-ping-pong - Responds with {'pong'} 70% of the time
- /chance-ping-pong - Responds with {'ping'} 50% of the time and {'pong'} 50% of the time

## Description
This is a simple API to test that the RapidAPI/Mashape API Proxy is working. When you access /ping, the API will return a JSON that contains "pong"

## Test Endpoints
API is live at https://rapidapi.com/user/RapidAlex/package/ping-pong

## Docker image
Install [docker](https://www.docker.com/products/docker-desktop/) on the build machine  

On Mac or any other ARM architecture export environment variable in the shell to support linux/amd64 
`export DOCKER_DEFAULT_PLATFORM=linux/amd64`

### Authenticate to docker repository  
```docker login -u username```

### Build and push image to the target repository
```docker build . -t <reponame>/pingpong:latest --push```

Replace **<reponame>** with your target repo where you have access to push.

Eg:
```
docker build . -t goranpp/pingpong:latest --push
```


### Providing cloud infrastructure 
Please follow [README.md](./terraform) in terraform directory

### Deploy application to the Kubnernetes
Please follow [README.md](./deployment) in deployment directory
