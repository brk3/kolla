#!/bin/bash

set -e

# TODO(pbourke): move to docker/common

. /opt/kolla/kolla-common.sh
. /opt/kolla/config-swift.sh

: ${SWIFT_CONTAINER_BIND_IP:=$PUBLIC_IP}
: ${SWIFT_CONTAINER_BIND_PORT:=6001}
: ${SWIFT_USER:=swift}
: ${SWIFT_DIR:=/etc/swift}
: ${SWIFT_CONTAINER_DEVICES:=/srv/node}
: ${SWIFT_CONTAINER_MOUNT_CHECK:=false}

#check_required_vars KEYSTONE_ADMIN_TOKEN NOVA_DB_PASSWORD \

cfg=/etc/swift/container-server.conf

# [DEFAULT]
crudini --set $cfg DEFAULT bind_ip "${SWIFT_CONTAINER_BIND_IP}"
crudini --set $cfg DEFAULT bind_port "${SWIFT_CONTAINER_BIND_PORT}"
crudini --set $cfg DEFAULT user "${SWIFT_USER}"
crudini --set $cfg DEFAULT swift_dir "${SWIFT_DIR}"
crudini --set $cfg DEFAULT devices "${SWIFT_CONTAINER_DEVICES}"
crudini --set $cfg DEFAULT mount_check "${SWIFT_CONTAINER_MOUNT_CHECK}"

# Create swift user and group if they don't exist
id -u swift &>/dev/null || useradd --user-group swift

# Ensure proper ownership of the mount point directory structure
chown -R swift:swift /srv/node

python /opt/kolla/build-swift-ring.py SWIFT_CONTAINER_RING_CONF

exec /usr/bin/swift-container-server /etc/swift/container-server.conf --verbose
