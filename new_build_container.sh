sudo docker create \
            --name pixty_container \
            --interactive \
            --tty \
            --volume ~/gh/build_docker/tests:/opt/compile_area/github.com/pixty \
            pixty_build_srv:latest
