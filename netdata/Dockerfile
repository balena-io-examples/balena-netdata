FROM alpine:3.12.0
RUN apk update
RUN apk add netdata --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
RUN apk add curl jq

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
COPY ./balenad.conf ./python.d/dockerd.conf

# TODO: File bug with Alpine about this
RUN mkdir /var/lib/netdata && \
	chown netdata:root /var/lib/netdata && \
	chmod 770 /var/lib/netdata
CMD ["/usr/sbin/netdata", "-D"]
