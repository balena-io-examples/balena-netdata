#!/usr/bin/env bash
#
# Entry point script for netdata
#
# Copyright: SPDX-License-Identifier: GPL-3.0-or-later
#
# Author  : Pavlos Emm. Katsoulakis <paul@netdata.cloud>
#
# BALENA_NOTES:
# - Upstream source: https://github.com/netdata/netdata/commit/9511af410de5e47f9e1fd7a0718dd98d82d6edb4
# - Removed Polymorphic Linux download

set -e

if [ ! "${DO_NOT_TRACK:-0}" -eq 0 ] || [ -n "$DO_NOT_TRACK" ]; then
  touch /etc/netdata/.opt-out-from-anonymous-statistics
fi

if [ -n "${PGID}" ]; then
  echo "Creating docker group ${PGID}"
  addgroup -g "${PGID}" "docker" || echo >&2 "Could not add group docker with ID ${PGID}, its already there probably"
  echo "Assign netdata user to docker group ${PGID}"
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

chown -R netdata:root /var/lib/netdata/cloud.d/
chmod -R 770 /var/lib/netdata/cloud.d/

# See https://github.com/netdata/netdata/issues/4173
# exec /usr/sbin/netdata -u "${DOCKER_USR}" -D -s /host -p "${NETDATA_PORT}" -W set web "web files group" root -W set web "web files owner" root "$@"
exec /usr/sbin/netdata -u "${DOCKER_USR}" -D -s /host -p "${NETDATA_PORT}" "$@"

echo "Netdata entrypoint script, completed!"
