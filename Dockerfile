# Set up StarCraft II Learning Environment
# docker run -it \
#        -e /bin/bash \
#        --name sc2ai
#         egsy/sc2ai
# Use an official Ubuntu release as a base image
FROM ubuntu:trusty
LABEL maintainer="Elaine Yeung <yeung.egs@gmail.com>"

# Add script to download files
ADD installblz.sh /root/

# Set bash as default
SHELL ["/bin/bash", "-c"]

# Update apt-get for gcc4.9
RUN apt-get update --assume-yes --quiet=2
RUN apt-get install --assume-yes --quiet=2 software-properties-common \
    python-software-properties

# Update and install packages for SC2 development environment
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update --assume-yes --quiet=2
RUN apt-get build-dep --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 python-pygame
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded --quiet=2 \
    build-essential gcc \
    emacs \
    git \
    python-pip \
    python-pygame \
    unzip \
    valgrind \
    vim \
    wget \
    build-essential \
    cmake3 \
    g++-4.9

# Set g++4.9 as default compiler by updating symbolic link
RUN ln -f -s /usr/bin/g++-4.9 /usr/bin/g++

# Set working directory to root
WORKDIR /root/

# Install pysc2
RUN pip install pysc2 \
 && export SC2PATH=~/StarCraftII/

# Install Blizzard S2Client API
RUN git clone --recursive https://github.com/Blizzard/s2client-api
WORKDIR s2client-api/
WORKDIR build/
RUN cmake ../
RUN make

# Set working directory to root
WORKDIR /root/
