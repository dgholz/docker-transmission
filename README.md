docker-transmission
===================

Transmission daemon running in a container. The default paths have been altered to:
 * /transmission/download
 * /transmission/incomplete
 * /transmission/torrents
 * /transmission/watch
 * /transmission/settings

Transmission runs as root; to run as a different user, share the host's /etc/passwd with this container & pass the --user flag to docker run:
    docker run -v /etc/passwd:/etc/passwd --user host_tranmission_user dgholz/transmission-daemon 
