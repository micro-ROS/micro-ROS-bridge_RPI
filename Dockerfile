FROM ubuntu:bionic

# Set timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# 1. Install development tools
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    lsb-core \
    bash-completion \
    libparted-dev \
    libparted \
    pkg-config \
    libtinyxml2-dev

# ROS2 tools
RUN apt update
RUN apt install -y \
    python3-pip \
    python3-numpy \
    python3-parted

RUN python3 -m pip install -U \
    colcon-common-extensions \
    rosdep \
    vcstool \
    lark-parser \
    requests \
    pyparted \
    lxml

# Install Docker
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install -y docker-ce

RUN apt install sudo

RUN mkdir root/cc_ws

RUN cd ~/ && wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-bridge_RPI/feature/docker/micro-ROS-Agent_Cross-Compilation/cc_script.sh && chmod +x cc_script.sh

ENTRYPOINT ["~/cc_script.sh"]
CMD ["bash"]
