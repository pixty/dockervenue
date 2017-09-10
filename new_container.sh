sudo docker create \
            --name pixty_build_service \
            --interactive \
            --tty \
            --volume ~/gh/build_docker/tests:/opt/compile_area/github.com/pixty \
            --device=/dev/video0:/dev/video0 \
            pixty_build_srv:latest
