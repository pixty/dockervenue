# dockervenue
Docker containers

Please install latest version of docker:
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
Also enable experimental features. It is needed to use the squash command key for building the image.

The pixty_build_service container is used to build the frame_processor/fpcp_grpc for the intel atom box.

The new_container.sh needs to be aletred.
The volume should point to your pixty directory and probably /dev/video0 shall be changed.

Please consider installing a proxy to speedup docker's apt-get: 

sudo apt-get install -y squid-deb-proxy

Then run: sudo make build_image
