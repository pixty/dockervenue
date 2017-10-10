FROM    ubuntu:artful-20170826
# 16.04, xenial-20170802
# 17.04, zesty-20170703
# 17.10, artful-20170826

#################################################################################
# Dumb caching, sorry about that ...
# install the proxy on the HOST to speedup docker's apt-get by caching
# sudo apt-get install -y squid-deb-proxy
# typicaly it runs on 8000 port
#ARG APT_PROXY_PORT=
#COPY ./detect-proxy.sh ./optimizations.sh /root/scripts/apt/

#RUN /root/scripts/apt/optimizations.sh && \
#    /root/scripts/apt/detect-proxy.sh ${APT_PROXY_PORT} && \
#    # Cleanup
#    rm -rf /root/scripts
# End of caching
#################################################################################

# Install all missing updates.
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y apt-utils tzdata locales && \
    apt-get install -y unattended-upgrades && \
    apt-get autoremove -y && \
    unattended-upgrades --debug

# Setup locale en_US.UTF-8.
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Configure non-interactive mode.
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y \
                       # c/c++, env
                       build-essential cmake git curl ccache daemontools \
                       # GRPC
                       autoconf libtool clang libc++-dev libgflags-dev libgtest-dev \
                       # OPENCV::GUI
                       libgtkglext1-dev \
                       # OPENCV::Media I/O
                       zlib1g-dev libjpeg-dev libwebp-dev libpng-dev \
                       libtiff5-dev libopenexr-dev libgdal-dev \
                       # OPENCV::Video I/O
                       libdc1394-22-dev libavcodec-dev libavformat-dev \
                       libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev \
                       libx264-dev yasm libopencore-amrnb-dev \
                       libopencore-amrwb-dev libv4l-dev libxine2-dev \
                       # OPENCV::Parallelism and linear algebra libraries
                       libtbb2 libtbb-dev libeigen3-dev \
                       # DLIB:: Openblas
                       libopenblas-dev liblapacke-dev \
                       # Frame processor
                       libboost-all-dev \
                       # Tools
                       v4l-utils && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download grpc
ARG COMPILE_ROOT=/compile_root
RUN mkdir $COMPILE_ROOT && \
    # Build grpc
    cd $COMPILE_ROOT && \
    git clone https://github.com/grpc/grpc && \
    cd grpc && \
    git checkout tags/v1.4.6 && \
    git submodule update --init --recursive

# Download opencv
RUN cd $COMPILE_ROOT && \
    git clone https://github.com/opencv/opencv && \
    cd opencv && \
    git checkout tags/3.3.0 && \
    mkdir build


# Build c++ libraries
# gcc: processor specific options of the target processor
# To get the glue run the command below on the target platform
#   $ gcc -### -march=native /usr/include/stdlib.h
ENV CFLAGS -pipe -fomit-frame-pointer \
"-march=silvermont" -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a \
-mcx16 -msahf -mmovbe -maes -mno-sha -mpclmul -mpopcnt -mno-abm -mno-lwp \
-mno-fma -mno-fma4 -mno-xop -mno-bmi -mno-sgx -mno-bmi2 -mno-tbm -mno-avx -mno-avx2 \
-msse4.2 -msse4.1 -mno-lzcnt -mno-rtm -mno-hle -mrdrnd -mno-f16c -mno-fsgsbase \
-mno-rdseed -mprfchw -mno-adx -mfxsr -mno-xsave -mno-xsaveopt -mno-avx512f \
-mno-avx512er -mno-avx512cd -mno-avx512pf -mno-prefetchwt1 -mno-clflushopt \
-mno-xsavec -mno-xsaves -mno-avx512dq -mno-avx512bw -mno-avx512vl -mno-avx512ifma \
-mno-avx512vbmi -mno-avx5124fmaps -mno-avx5124vnniw -mno-clwb -mno-mwaitx -mno-clzero \
-mno-pku -mno-rdpid --param "l1-cache-size=24" --param "l1-cache-line-size=64" \
--param "l2-cache-size=1024" "-mtune=generic"

ENV CXXFLAGS $CFLAGS

RUN cd $COMPILE_ROOT/grpc && \
    make -j4 CFLAGS="$(CFLAGS) -Wno-error" \
             CXXFLAGS="$(CXXFLAGS) -Wno-error" && \
    make install && \
    ldconfig && \
    # Install protobuf ('make' should have been run by core grpc)
    cd $COMPILE_ROOT/grpc/third_party/protobuf && \
    make install && \
    ldconfig && \
    # Cleanup
    rm -rf $COMPILE_ROOT/grpc $COMPILE_ROOT/protobuf

RUN cd $COMPILE_ROOT/opencv/build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DWITH_OPENGL=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
          -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF .. && \
    make -j4  && \
    make install  && \
    ldconfig

# Install go 
# Choose version
ARG GO_VERSION=1.9
# Latest 1.8.X=1.8.3
ARG GO_ARC=go$GO_VERSION.linux-amd64.tar.gz

ARG GO_BASE=/usr/local/go
ARG GO_INSTALL=$GO_BASE/$GO_VERSION

ENV GOROOT=$GO_BASE/default
ENV GOPATH=/opt/compile_area
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

RUN cd $COMPILE_ROOT && \
    curl -O https://storage.googleapis.com/golang/$GO_ARC && \
    mkdir -p $GO_INSTALL && \
    tar --directory $GO_INSTALL -xzf $GO_ARC && \
    ln -s $GO_INSTALL/go $GOROOT && \
    mkdir -p $GOPATH

# Install grpc
RUN go get -u google.golang.org/grpc
RUN go get -u github.com/golang/protobuf/proto
RUN go get -u github.com/golang/protobuf/protoc-gen-go

# Cleanup
RUN rm -rf $COMPILE_ROOT

# Define working directory
ARG WORK_DIR=$GOPATH/github.com/pixty
RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

# Define default command
CMD ["/bin/bash"]
