
all:
	@echo "Please consider installing a proxy to speedup docker's apt-get: \
	sudo apt-get install -y squid-deb-proxy"
	@echo "Then run: sudo make build_image"

build_image:
	@docker build --squash --rm --build-arg APT_PROXY_PORT=8000 \
	-t pixty_build_srv -f ./images/build_srv/Dockerfile ./images/build_srv
