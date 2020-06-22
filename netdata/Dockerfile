FROM alpine:3.12.0
ENV DOCKER_GRP netdata
ENV DOCKER_USR netdata

ENV NETDATA_PORT 19999

RUN apk update
RUN apk add netdata --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
RUN apk add curl \
	jq \
	shadow

WORKDIR /etc/netdata

# TODO: Copying in netdata.conf from repo results in "Access to file
# is not permitted: /usr/share/webapss/netdata//index.html" error in
# dashboard.  I'll track down later.  In the meantime, we remove these
# two lines to let the daemon listen on all addresses.
RUN sed -i -e'/# by default do not expose the netdata port/,+1d' ./netdata.conf
# COPY ./netdata.conf /etc/netdata/netdata.conf

# TODO: Originally, I didn't copy this in and saw my containers listed
# (though with UUIDs only, which is probably a limitation of the
# 2.48.0 balenaOS I'm running).  Now that I copy this back in, I'm not
# seeing containers listed.  Not sure what's going on; I'll track down
# later.  In the meantime, leaving it in here.
RUN mkdir ./python.d
COPY ./balenad.conf ./python.d/dockerd.conf

COPY ./rpi-charts.d.conf ./charts.d.conf

# Upstream bug: https://gitlab.alpinelinux.org/alpine/aports/-/issues/11678
RUN mkdir /var/lib/netdata && \
	chown netdata:root /var/lib/netdata && \
	chmod 770 /var/lib/netdata

COPY ./upstream-docker-run.sh /usr/sbin/upstream-docker-run.sh
ENTRYPOINT ["/usr/sbin/upstream-docker-run.sh"]
