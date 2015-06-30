#!/bin/bash

set -e

# TODO(pbourke): move to docker/common

. /opt/kolla/kolla-common.sh
. /opt/kolla/config-swift.sh
. /opt/kolla/config-swift-object.sh

exec /usr/bin/swift-object-expirer /etc/swift/object-server.conf --verbose
