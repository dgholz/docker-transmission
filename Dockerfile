FROM debian:jessie

MAINTAINER Daniel Holz <dgholz@gmail.com>

RUN apt-get update
RUN apt-get install -y transmission-daemon 
RUN mkdir /transmission
RUN chmod 1777 /transmission

ENV TRANSMISSION_HOME /transmission/config

# Transmission ports
#   HTTP interface
EXPOSE 9091

USER debian-transmission

RUN mkdir /transmission/download
RUN mkdir /transmission/watch
RUN mkdir /transmission/incomplete
RUN mkdir /transmission/config

CMD [ "--watch-dir", "/transmission/watch", "--encryption-preferred", "--foreground", "--config-dir", "/transmission/config", "--global-seedratio", "1", "--incomplete-dir", "/transmission/incomplete", "--portmap", "--dht", "--no-auth", "--download-dir", "/tranmission/download" ]
ENTRYPOINT ["/usr/bin/transmission-daemon"]
