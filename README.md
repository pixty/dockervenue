# dockervenue
Docker containers. Please use them to build frame-processor on a host machine AND to run it on the box. The existing configuration is targeted to Atom box Intel x64 architecture.

Please install latest version of docker:
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

## On Mac
1. You don't need proxy, so go to the dockerfile (images/build_srv/Dockerfile) and comment ALL lines related to the proxy (##6-19)
2. type `sudo make build_image`

## On Linux
1. Check enable experimental features - they are enabled by default. It is needed to use the squash command key (linux ) for building the image. Only if the proxy will be enabled

The new_container.sh needs to be altered.
The volume should point to your pixty directory and probably /dev/video0 shall be changed.

Please consider installing a proxy to speedup docker's apt-get: 

sudo apt-get install -y squid-deb-proxy

Then run: sudo make build_image

See the box directory for details about how-to use the image on the real hardware
