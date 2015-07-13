#!/bin/bash

set -e

CMD="/usr/bin/swift-object-replicator"
ARGS="/etc/swift/object-server.conf --verbose"

. /opt/kolla/kolla-common.sh

set_configs

exec $CMD $ARGS
