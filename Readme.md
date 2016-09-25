# Docker Gulp image

Docker image to work with Firefox and Chrome.

<img src="img/firefox.jpg" height="125" />
<img src="img/docker_logo.png" height="125" />
<img src="img/chrome.png" height="125" />

## Table of Contents
  - [Requirements](#requirements)
  - [Docker build](#docker-build)
  - [Docker run](#docker-run)
  - [Docker stop](#docker-stop)
  - [Docker cheat sheet](https://github.com/wsargent/docker-cheat-sheet)
  - [Cleaning untagged images](#cleaning-untagged-images)

## Requirements

You have to install [Docker](https://www.docker.com/) following the [installation steps](https://docs.docker.com/engine/installation/) (choose your OS).

## Docker Build

There are two options to build the image:

### 1) Building the entire image

You can build the app from this directory running:

```
docker build -t agomezmoron/docker-browsers .
```

If you want to choose a custom Firefox version and/or defining the VNC password:

```
docker build --build-arg FIREFOX_VERSION=47.0.1 --build-arg VNC_PASSWD=1234 - -t agomezmoron/docker-browsers .
```

### 2) Pulling from Docker

You can pull the image from Docker:

```
docker pull agomezmoron/docker-browsers (pending to be uploaded)
```

## Docker Run

Run the image with the following command:

```
docker run --privileged -v /YOUR/TESTS/FOLDER:/src -p 90:8080  -e GULP_TASK="YOUR_GULP_TASK" -t -i agomezmoron/docker-gulp
```

or

```
docker run --privileged -v /YOUR/TESTS/FOLDER:/src -p  -e GULP_TASK="YOUR_GULP_TASK" -d -t -i agomezmoron/docker-gulp
```


**Important:** If you are running Docker on Windwos, please check you have the shared drives enabled:

<img src="img/docker_settings_windows.png" />
<img src="img/docker_shared_windows.png" />


## Docker Stop

Once Docker is running our image, there is a way to stop it:

 * Execute **docker ps** and you will get the Container ID.
 * Then, execute **docker kill CONTAINER_ID** and the Docker image will be stoped.

## Cleaning untagged images

If you want to clean all the untagged images you have in your Docker you can perform:

```
docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null
```

and it will detelete all the past images of the builds, so the PC does not end up with several duplicated images. It can be removed without affecting the build.
