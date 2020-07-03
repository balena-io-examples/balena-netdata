#!/usr/bin/env bash
#
# Entry point script for netdata; rewrite of upstream startup script.

# Opt out of usage gathering
touch /etc/netdata/.opt-out-from-anonymous-statistics

if [[ "${PGID}" ]]; then
  echo "Creating docker group ${PGID}"
  addgroup -g "${PGID}" "docker" || echo >&2 "Could not add group docker with ID ${PGID} -- is it already there?"
  echo "Adding netdata user to docker group ${PGID}"
  usermod -a -G "${PGID}" "${DOCKER_USR}" || echo >&2 "Could not add netdata user to group docker with ID ${PGID}"
fi

# This disables Agent-Cloud functionality
# (https://learn.netdata.cloud/docs/agent/aclk#disable-the-aclk);
# practically speaking, this removes the "Sign in" buttons for Netdata
# Cloud.

mkdir -p /var/lib/netdata/cloud.d
cat > /var/lib/netdata/cloud.d/cloud.conf <<EOF
[global]
  enabled = no
EOF

# Set ownership correctly; this handles the case where the volumes
# were attached to an earlier version of the container, with a
# different uid for the netdata user.
chown -R netdata:netdata /var/cache/netdata/
chown -R netdata:netdata /var/lib/netdata

chown -R netdata:root /var/lib/netdata/cloud.d
chmod -R 770 /var/lib/netdata/cloud.d/

exec /usr/sbin/netdata -u "${DOCKER_USR}" -D -s /host -p "${NETDATA_PORT}" "$@"

