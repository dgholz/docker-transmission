FROM debian:trixie-slim

RUN ["/bin/bash", "-c", "mkdir /transmission/{,download,watch,incomplete,config}"]

RUN apt-get update --quiet=2 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --quiet=2 --no-install-recommends \
      transmission-daemon \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists

ENV TRANSMISSION_HOME=/transmission/config
# Transmission HTTP interface
EXPOSE 9091

CMD [ "--allowed", "127.*,10.*,192.168.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,172.28.*,172.29.*,172.30.*,172.31.*,169.254.*", "--watch-dir", "/transmission/watch", "--encryption-preferred", "--foreground", "--config-dir", "/transmission/config", "--incomplete-dir", "/transmission/incomplete", "--dht", "--no-auth", "--download-dir", "/transmission/download" ]
ENTRYPOINT [ "/usr/bin/transmission-daemon" ]
