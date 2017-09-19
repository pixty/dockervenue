# Box

Copy content of this directory into /home/pixty/Development/dockervenue/product directory on the box

Copy dlib_face_recognition_resnet_model_v1.dat and shape_predictor_68_face_landmarks.dat 

 from https://github.com/pixty/frame_processor/resource/models

 into /home/pixty/Development/dockervenue/product/frame_processor

An image can be saved to a file:
sudo docker save --output image.name IMAGE_ID

And image can be loaded from a file
sudo docker load --input image.name

A tag can be easily created
sudo docker tag 422ed pixty_build_srv:ubuntu_17_10
sudo docker tag 422ed pixty_build_srv:latest
where 422ed is the image id

# Description

create - creates a new container. It fails if the container has been already created.

start - start the container

stop - stop the container

./dbg/connect - execute a new shell inside of the running container

