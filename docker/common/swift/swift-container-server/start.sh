#!/bin/bash

set -e

CMD="/usr/bin/swift-container-server"
ARGS="/etc/swift/container-server.conf --verbose"

. /opt/kolla/kolla-common.sh

set_configs

exec $CMD $ARGS
