docker-transmission
===================

Transmission daemon running in a container. The default paths have been altered to:
 * /transmission/download
 * /transmission/incomplete
 * /transmission/watch
 * /transmission/config

Transmission runs as root; to run as a different user, share the host's /etc/passwd with this container & pass the --user flag to docker run:
    docker run -v /etc/passwd:/etc/passwd --user host_tranmission_user dgholz/transmission-daemon 

I set `portmap: true` in config but the port is still closed! What gives?
=========================================================================

Transmission sends out a NAT-PMP (uPNP) packet to your router, asking it to forward connection to some port back to the same port at the address Tranmission is running on. Docker 

I'm volume-mounting a directory that is owned by some user, and I want Transmission to run as that user so it can create files. What should I do?
=================================================================================================================================================

Mount `/etc/passwd` and use the `--user` command-line option:
    docker run --volume /host/download/dir:/transmission/download --volume /etc/passwd:/etc/passwd:ro --user some_user dgholz/docker-transmission
