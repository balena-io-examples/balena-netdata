FROM alpine:3.12.0
ENV DOCKER_GRP netdata
ENV DOCKER_USR netdata

ENV NETDATA_PORT 19999

RUN apk update && \
	apk add netdata --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted && \
	apk add curl \
		jq \
		shadow

WORKDIR /etc/netdata

COPY ./netdata.conf ./netdata.conf
COPY ./balenad.conf ./python.d/dockerd.conf

# Note: see `upstream-docker.run.sh` for where
# /var/lib/netdata/cloud.d/cloud.conf is created; as this is a static
# volume, we need to create it in the startup script.
COPY ./startup.sh /usr/sbin/startup.sh

ENTRYPOINT ["/usr/sbin/startup.sh"]
