#!/bin/bash

set -e

CMD="/usr/bin/swift-proxy-server"
ARGS="/etc/swift/proxy-server.conf --verbose"

. /opt/kolla/kolla-common.sh

set_configs

exec $CMD $ARGS
