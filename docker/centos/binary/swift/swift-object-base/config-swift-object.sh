#!/bin/bash

# TODO(pbourke): move to docker/common

. /opt/kolla/kolla-common.sh

: ${BIND_IP:=$PUBLIC_IP}
: ${BIND_PORT:=6000}
: ${USER:=swift}
: ${SWIFT_DIR:=/etc/swift}
: ${DEVICES:=/srv/node}
: ${PIPELINE:=object-server}
: ${MOUNT_CHECK:=false}

#check_required_vars KEYSTONE_ADMIN_TOKEN NOVA_DB_PASSWORD \

cfg=/etc/swift/object-server.conf

# [DEFAULT]
crudini --set $cfg DEFAULT bind_ip "${BIND_IP}"
crudini --set $cfg DEFAULT bind_port "${BIND_PORT}"
crudini --set $cfg DEFAULT user "${USER}"
crudini --set $cfg DEFAULT swift_dir "${SWIFT_DIR}"
crudini --set $cfg DEFAULT devices "${DEVICES}"
crudini --set $cfg DEFAULT mount_check "${MOUNT_CHECK}"

# [pipeline:main]
crudini --set $cfg pipeline:main pipeline "${PIPELINE}"

# Create swift user and group if they don't exist
id -u swift &>/dev/null || useradd --user-group swift

# Ensure proper ownership of the mount point directory structure
chown -R swift:swift /srv/node

# Create the recon directory and ensure proper ownership of it
mkdir -p /var/cache/swift
chown -R swift:swift /var/cache/swift

# Generate object-ring
python /opt/kolla/build-swift-ring.py SWIFT_OBJECT_RING_CONF

# Generate container-ring
python /opt/kolla/build-swift-ring.py SWIFT_CONTAINER_RING_CONF
