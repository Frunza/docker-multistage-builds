# Docker multistage builds

## Scenario

If you are using more `dockerfile` files, you might run into cases where you have duplication. This can happen for example where you want to have a `dockerfile` where you copy your repository or a part of it in the container, and another one where you do not do that. How can we remove such a duplication?

## Prerequisites

A Linux or MacOS machine for local development. If you are running Windows, you first need to set up the *Windows Subsystem for Linux (WSL)* environment.

You need `docker cli` and `docker-compose` on your machine for testing purposes, and/or on the machines that run your pipeline.
You can check both of these by running the following commands:
```sh
docker --version
docker-compose --version
```

## Implementation

If you have a *buildDebug.dockerfile* file with the following content
```sh
FROM hashicorp/terraform:1.5.0

# Install required packages

# Setup additional tools

# Other configuration
```
, and a *build.dockerfile* file with the following content
```sh
FROM hashicorp/terraform:1.5.0

# Install required packages

# Setup additional tools

# Other configuration

# Copy app repo
COPY ./../terraform /infrastructure
```
, you notice that the only difference is the copy command in the *build.dockerfile* file. Everything else should be the same.

You would build these docker images with
```sh
docker build -t terraformwithvolumetest -f docker/buildDebug.dockerfile .
```
and
```sh
docker build -t terraformwithvolumetest -f docker/build.dockerfile .
```
commands.

The way to remove the duplication is to create a single *dockerfile* with more stages
```sh
FROM hashicorp/terraform:1.5.0 AS config_only

# Install required packages

# Setup additional tools

# Other configuration

FROM config_only AS copy_files

# Copy app repo
COPY ./../terraform /infrastructure
```
The `AS` keywork in the *dockerfile* will create stages that you can provide as parameters when building the image. So the commands to build the docker images become
```sh
docker build -t terraformwithvolumetest -f docker/dockerfile --target config_only .
```
and
```sh
docker build -t terraformwithvolumetest -f docker/dockerfile --target copy_files .
```
