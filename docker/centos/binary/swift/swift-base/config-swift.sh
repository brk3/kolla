#!/bin/bash

# TODO(pbourke): move to docker/common

. /opt/kolla/kolla-common.sh

: ${SWIFT_HASH_PATH_SUFFIX:=0123456789abcdef}

#check_required_vars KEYSTONE_ADMIN_TOKEN NOVA_DB_PASSWORD \

cfg=/etc/swift/swift.conf

# [DEFAULT]
crudini --set $cfg swift-hash swift_hash_path_suffix "${SWIFT_HASH_PATH_SUFFIX}"
