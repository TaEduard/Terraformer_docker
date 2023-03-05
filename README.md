# Terraformer_docker

This repository contains a Dockerfile that builds a Docker image with [Terraform](https://github.com/hashicorp/terraform) and [Terraformer](https://github.com/GoogleCloudPlatform/terraformer) installed.

## Getting Started
To use the Docker Hub Hosted Image run the following commands:

`docker pull taeduard/terraformer`
`docker run --rm -it taeduard/terraformer`


To build the Docker image, simply clone this repository and run the following command:
`docker build -t terraformer .`


Once the build is complete, you can run the Docker container with the following command:
`docker run --rm -it terraformer`

This will start the container and drop you into a command prompt.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](./LICENSE) file for details.
