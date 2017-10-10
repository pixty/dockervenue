# dockervenue
The repo contains a configuration and some commands to make a docker image which will be installed on a box for running Frame Processor (FP). The same image can be used for building FP on a host machine. Please use them to build the FP on a host machine AND to run it on the box. The existing configuration is targeted to Atom box Intel x64 architecture.

## Directory structure
`Makefile` - The root directory contains Makefile which simply builds an docker image with name *pixty_build_srv* 

`README.md` - the text is there

`new_build_container.sh` - creates a container from docker image (should be build first) without camera access. Used for building FP purposes only

`new_container.sh` - creates a container from docker image (should be build first) with camera access on the host system. Will work on Linux only. Should be used on box for running FP 

`start_container.sh` - starts existing container with name *pixty_container*

`connect_to_container.sh` - connects to started container 

`images/build_srv/Dockerfile` - the dockerfile to make the latest image 

## Install Docker
Please install latest version of docker:
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

## Building docker image 
You need to prepare a docker image first. 
### On Mac
1. You don't need apt-get proxy, so go to the dockerfile (images/build_srv/Dockerfile) and comment ALL lines related to the proxy (##6-19)
2. type `make build_image` from the root directory, or just symply run:
```
docker build --squash --rm -t pixty_build_srv -f ./images/build_srv/Dockerfile ./images/build_srv
```
### On Linux
1. Check enable experimental features - they are enabled by default. It is needed to use the squash command key (linux ) for building the image. Only if the proxy will be enabled
2. To install a proxy to speedup docker's apt-get: 
```
sudo apt-get install -y squid-deb-proxy
```
3. type `make build_image` from the root directory

## Moving docker image
To move docker image you can use the following commands:
```
#to store docker image
docker save --output pixty_docker.img IMAGE_ID

#to restore docker image
docker load --input filename.img
```

## Building Frame Processor in the container
1. Start the container, mounting FP sources to the container. To do this, please replace the *<FP_SRC_PATH>* by the path to the frome processor and run the command:
```
docker run --name pixty_container --interactive --tty --volume <FP_SRC_PATH>:/opt/compile_area/github.com/pixty pixty_build_srv:latest
```
when the command is run you will be in the container terminal ready to build frame processor.
2. Go to `/opt/compile_area/github.com/pixty` which should be mounted onto your host system with FP sources then type the following commands to build the frame_processor for the target system:
```
cd /opt/compile_area/github.com/pixty
mkdir build_box
cd build_box
cmake ..
make 
```
3. When the build is ready you can find the `frame_processor` executable by *<FP_SRC_PATH>/build_box/src/bin* path on your host system.
4. You can use the following commands to stop container:
```
docker stop pixty_container
```
run it again
```
docker start pixty_container
```
or delete it:
```
docker rm pixty_container
```
## Running frame processor on the box
To run the Frame Processor on the box, we need to have the docker image there, to run a container for the image and run the frame processor in the container then. The following commands do it.
1. To install already built container on the box use the command:
```
sudo docker load --input ./pisty_docker.img
```
To figure out what the loaded image id try `sudo docker images`
2. To run the image with video camera enabled:
```
sudo docker run --name pixty_container --interactive --tty --volume /opt/pixty:/opt/pixty --device=/dev/video0:/dev/video0 3733a09986f4
```
In the command above the docker imageid is *3733a09986f4*. When you run the container, it will open the container console if the run is successfull. 
3. Run the frame processor:
```
./frame_processor --res_path /opt/pixty/resource/models/ --scn_no_visual 1 --access_key=1 --secret_key=fkf83I90o1 --sp_address=api.pixty.io:50051
```

