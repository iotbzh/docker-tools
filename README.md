# docker-tools
Collection of Linux bash scripts to ease operations on docker containers, and most notably to have containers running with fixed IP adresses

## Installation

First, clone the Git repository and enter in directory:
```
# git clone https://github.com/iotbzh/docker-tools.git
# cd docker-tools
```

Run the following command as root to install the scripts:
```
# make install
```
or
```
# sudo make install
```

Scripts will be installed in /usr/local/bin by default. 

To change the prefix, add the PREFIX variable in command line, for example:
```
# make install PREFIX=/usr
```

## Available commands

### docker-run-host
This command wraps 'docker run' and docker-net-start (see below).

Example:
```
# assuming that 'host1' is defined in /etc/hosts or local DNS
docker-run-host debian:latest host1
```

### docker-netstart
This command will assign a fixed IP address and hostname to the specified container. 

The container must be previously run with option --net=none.

Example:
```
HOSTNAME=host1
IMAGE=debian:latest
docker run --detach=true --net=none --hostname=$HOSTNAME --name=$HOSTNAME \
  --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -it $IMAGE
docker-netstart $HOSTNAME
```

### docker-enter
Enters into a container by executing /bin/bash. This is simply a shortcut to 'docker exec'

Example:
```
# docker-enter host1
root@host1:/#
```

### docker-listimages
List repositories and images on Docker registry 2.0 server

Example:
```
# docker-listimages dockreg 443
Images catalog on Docker registry: dockreg:443
dockreg:443/iotbzh/centos:7
dockreg:443/iotbzh/centos:latest
dockreg:443/iotbzh/debian:7.4
dockreg:443/iotbzh/debian:latest
dockreg:443/iotbzh/dockreg:2.1.1
dockreg:443/iotbzh/lamp:7
dockreg:443/iotbzh/portus:1.0.1
dockreg:443/iotbzh/mediawiki:1.25.2
dockreg:443/iotbzh/opensuse:13.2
dockreg:443/iotbzh/opensuse:latest
dockreg:443/iotbzh/owncloud:8.1
dockreg:443/iotbzh/owncloud:8.2.0
dockreg:443/iotbzh/true:1.0
dockreg:443/iotbzh/true:latest
```
