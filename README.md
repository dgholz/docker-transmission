docker-transmission
===================

Transmission daemon running in a container. The default paths have been altered to:
 * /transmission/download
 * /transmission/incomplete
 * /transmission/watch
 * /transmission/config

`transmission-daemon` runs as root, with the HTTP RPC interface listening on TCP port 9091, and the BitTorrent transfer port listening on TCP & UDP 51413. The HTTP RPC interface is configured to not use authentication, and allows connections from all private IP ranges (127.0.0.0/8, 10.0.0.0/8, 192.168.0.0/16, 169.254.0.0/16, 172.16.0.0/22).

Quick-start
===========

    docker run --daemon --volume /where/to/save/downloads:/transmission/download --port 9091:9091 --port 51413:51413 --port 51413:51413/udp --name transmission dgholz/docker-transmission

Then open http://docker_host:9091/transmission/web/ in a browser.

I want to run the HTTP RPC interface on a different port
========================================================

Easy! Just change the port mapping given to `docker run`; e.g. to listen on port 8080:
    docker run --port 8080:9091 dgholz/docker-transmission

I want the downloaded files to be owned by a different user
===========================================================

Run the container as that user. You must share the host's /etc/passwd with this container & pass the `--user` flag to `docker run`:
    docker run --volume /etc/passwd:/etc/passwd:ro --user host_tranmission_user dgholz/transmission-daemon

I set `portmap: true` in config but the port is still closed! What gives?
=========================================================================

Transmission sends out a NAT-PMP (uPNP) packet to your router, asking it to forward connection to some port back to the same port at the address Tranmission is running on. Docker created a private internal network for your container, and NATs the traffic through the host Docker is running on. DOcker don't understand the uPNP packet, and isn't allowed to forward it, so it gets dropped.

Solutions:
  1. use `--net=host` so Docker does not set up NATting of the traffic from the container
  1. statically forward port 51413 TCP & UDP to the docker host from your router
  1. teach Docker how to handle uPNP (hard)

Your chosen settings for Transmission are weird and I want to specify my own
============================================================================

Transmission will save its settings when it quits; if you volume-mount its config directory, you can get a copy:
    mkdir transmission-config
    docker run --interactive=true --tty=true --rm=true --volume $(pwd)/transmission-config:/transmission/config dgholz/docker-transmission
    [... wait for it to initialize ...]
    ^C
    [... wait for it to shut down ...]
    cp transmission-config/settings.json transmission-settings.json
    rm -rf transmission-config
    [... edit the transmission-settings.json file ...]
    docker run --volume $(pwd)/transmission-settings.json:/transmission/config/settings.json dgholz/docker-transmission --

How can I see the output from transmission-daemon?
==================================================

You can attach to a running container:
    docker attach --sig-proxy=false $(docker ps | grep transmi | cut -f1 -d' '')
Then Ctrl-C to detach
