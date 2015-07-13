#!/bin/bash

set -e

CMD="/usr/bin/swift-account-server"
ARGS="/etc/swift/account-server.conf --verbose"

. /opt/kolla/kolla-common.sh

set_configs

exec $CMD $ARGS
