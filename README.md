# Converse development environment for Docker

This environment was set up for frontend development purpose on the standard Converse environment. That set up gives you access to a local repository that is a volume mounted by the Docker container on your local machine. You can then use your usual IDE to perform changes and test them against the Converse installation on Docker.

It has been tested against version 4.2 of Converse.

## Requirements
* Docker needs to be installed on the machine that will run this environment
* Make sure that Docker have the correct rights on the directory you wish to work on

## Instruction
* Download or clone this package in a local directory
* Edit the device field of the file docker-compose.yml has to be edited to reflect your own environment
* Create the folder related to the device you set up at the previous step 
* Run the shell command `docker-compose up -d` in the directory where the docker-compose.yml file is present
* By default, the team chat will be available at you `localhost:381` address
* Stop the container by executing in your shell `docker stop container-conversejs`
